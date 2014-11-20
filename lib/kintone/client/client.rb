class Kintone::Client
  ENDPOINT = 'https://%s.cybozu.com'

  def initialize(options)
    @auth = {}
    @raw = options.delete(:raw)

    [:login_name, :password, :api_token].each do |k|
      @auth[k] = options.delete(k)
    end

    options[:url] ||= ENDPOINT % options.delete(:subdomein)

    @conn = Faraday.new(options) do |faraday|
      faraday.request  :url_encoded
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter
      yield(faraday) if block_given?
    end
  end

  private

  def method_missing(method_name, *args)
    unless args.length.zero?
      raise ArgumentError, "wrong number of arguments (#{args.length} for 0)"
    end

    Path.new(@conn, @auth, @raw, method_name.to_s)
  end

  class Path
    BASE_PATH = '/k/v1'

    def initialize(conn, auth, raw, path)
      @conn = conn
      @auth = auth
      @raw = raw
      @path = path
    end

    private

    def request(method_name, params)
      response = @conn.send(method_name) do |req|
        req.url BASE_PATH + '/' + @path + '.json'
        req.params = params
        authorize(req)
        yield(req) if block_given?
      end

      response.body
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

        self.class.new(@conn, @auth, @raw, @path + '/' + method_name.to_s)
      end
    end
  end # class Path
end # class Kintone::Client
