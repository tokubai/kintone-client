class Kintone::Client
  ENDPOINT = 'https://%s.cybozu.com'

  def initialize(options)
    @auth = {}

    if options[:api_token]
      @auth[:api_token] = options.delete(:api_token)
    else
      [:login_name, :password].each do |k|
        @auth[k] = options.fetch(k)
        options.delete(k)
      end
    end

    unless options[:url]
      options[:url] = ENDPOINT % options.fetch(:subdomain)
      options.delete(:subdomain)
    end

    @conn = Faraday.new(options) do |faraday|
      faraday.request  :url_encoded
      faraday.response :form, :content_type => /\bjson$/ # must set before :json
      faraday.response :json, :content_type => /\bjson$/

      yield(faraday) if block_given?

      required_adapters = [Faraday::Adapter::NetHttp, Faraday::Adapter::Test]

      unless required_adapters.any? {|i| faraday.builder.handlers.include?(i) }
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  private

  def method_missing(method_name, *args)
    unless args.length.zero?
      raise ArgumentError, "wrong number of arguments (#{args.length} for 0)"
    end

    Path.new(@conn, @auth, method_name.to_s)
  end

  class Path
    BASE_PATH = '/k/v1'

    def initialize(conn, auth, path)
      @conn = conn
      @auth = auth
      @path = path
    end

    private

    def request(method_name, params)
      response = @conn.send(method_name) do |req|
        req.url BASE_PATH + '/' + @path + '.json'
        req.params = expand_params_array(params || {})
        authorize(req)
        yield(req) if block_given?
      end

      body = response.body

      if response.status != 200
        raise body.kind_of?(Hash) ? Kintone::Error.new(body) : body.inspect
      end

      body
    end

    def expand_params_array(params)
      params.keys.each do |key|
        value = params[key]

        if can_be_expanded?(value)
          params.delete(key)

          value.each_with_index do |v, i|
            params["#{key}[#{i}]"] = v
          end
        else
          params[key] = expand_params_array0(value)
        end
      end

      params
    end

    def expand_params_array0(value)
      case value
      when Array
        value.map {|v| expand_params_array0(v) }
      when Hash
        expand_params_array(value)
      else
        value
      end
    end

    def can_be_expanded?(value)
      value.kind_of?(Array) &&
      value.all? {|v| not v.kind_of?(Array) and not v.kind_of?(Hash) }
    end

    def authorize(req)
      if @auth[:api_token]
        req.headers['X-Cybozu-API-Token'] = Base64.strict_encode64(@auth[:api_token])
      elsif @auth[:login_name] and @auth[:password]
        req.headers['X-Cybozu-Authorization'] = Base64.strict_encode64(
          @auth[:login_name] + ':' + @auth[:password])
      else
        raise 'no auth parameter (:api_token or :login_name,:password)'
      end
    end

    def method_missing(method_name, *args, &block)
      if [:get, :post, :put, :delete].include?(method_name)
        case args.length
        when 0
          args = nil
        when 1
          args = args.first
        end

        request(method_name, args, &block)
      else
        unless args.length.zero?
          raise ArgumentError, "wrong number of arguments (#{args.length} for 0)"
        end

        self.class.new(@conn, @auth, @path + '/' + method_name.to_s)
      end
    end
  end # class Path
end # class Kintone::Client
