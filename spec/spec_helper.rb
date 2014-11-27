require 'kintone/client'

TEST_AUTH_HEADER = 'c2NvdHQ6dGlnZXI='

def kintone_client
  stubs = Faraday::Adapter::Test::Stubs.new

  Kintone::Client.new(subdomein: 'foo', login_name: 'scott', password: 'tiger') do |faraday|
    faraday.adapter :test, stubs do |stub|
      yield(stub)
    end
  end
end

def params_from_url(env)
  query = URI.parse(env.url.to_s).query
  query ? URI.decode(query) : query
end