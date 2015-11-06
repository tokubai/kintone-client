module Kintone::Client::Middleware
  class Form < Faraday::Response::Middleware
    def initialize(app, options = nil)
      super(app)
    end

    def call(env)
      @app.call(env).on_complete do |env|
        if record = env[:body]['record']
          env[:body]['record'] = parse_form(record)
        elsif records = env[:body]['records']
          env[:body]['records'] = records.map {|r| parse_form(r) }
        end

        if totalCount = env[:body]['totalCount']
          env[:body]['totalCount'] = totalCount.to_i
        end
      end
    end

    private

    def parse_form(form)
      parsed = {}

      form.each do |name, field|
        parsed[name] = parse_field(field)
      end

      parsed
    end

    def parse_field(field)
      field_type  = field['type']
      field_value = field['value']

      if field_type == 'SUBTABLE'
        subtable = {}

        field_value.each do |row|
          subtable[row['id']] = parse_form(row['value'])
        end

        subtable
      else
        field_value
      end
    end
  end
end

Faraday::Response.register_middleware :form => Kintone::Client::Middleware::Form
