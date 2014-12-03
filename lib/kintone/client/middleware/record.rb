module Kintone::Client::Middleware
  class Record < Faraday::Middleware
    def initialize(app, options = {})
      super(app)
      @options = options
    end

    def call(env)
      match_content_type(env) do
        env[:body] = expand_body(env[:body])
      end

      @app.call env
    end

    private

    def match_content_type(env)
      content_type = env[:request_headers]['Content-Type']

      return unless content_type

      content_type = content_type.split(';').first.strip
      opt_content_type = @options[:content_type] || /.*/

      if env[:body] and opt_content_type =~ content_type
        yield
      end
    end

    def expand_body(body)
      body = JSON.parse(body)

      if body['record']
        body['record'] = expand_record(body['record'])
      elsif body['requests']
        if_has_record do |request|
          record = request['payload']['record']
          next unless record
          request['payload']['record'] = expand_record(record)
        end
      end

      JSON.dump(body)
    end

    def expand_record(record)
      expanded = {}

      record.each do |key, value|
        case value
        when Array, Hash
          expanded[key] = value
        else
          expanded[key] = {
            'value' => value.to_s
          }
        end
      end

      expanded
    end

    def if_has_record
      if body['requests'][0]['payload']['record']
        body['requests'].each do |request|
          yield(request)
        end
      end
    rescue
      # nothing to do
    end
  end
end

Faraday::Request.register_middleware :record => Kintone::Client::Middleware::Record
