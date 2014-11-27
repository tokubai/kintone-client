require 'kintone/client'

TEST_AUTH_HEADER = 'c2NvdHQ6dGlnZXI='

def kintone_client
  stubs = Faraday::Adapter::Test::Stubs.new

  Kintone::Client.new(login_name: 'scott', password: 'tiger') do |faraday|
    faraday.adapter :test, stubs do |stub|
      yield(stub)
    end
  end
end
