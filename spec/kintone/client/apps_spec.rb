# https://cybozudev.zendesk.com/hc/ja/articles/202931674-%E3%82%A2%E3%83%97%E3%83%AA%E6%83%85%E5%A0%B1%E3%81%AE%E5%8F%96%E5%BE%97#step2
describe Kintone::Client do
  describe 'アプリ情報の一括取得' do
    let(:response) do
      {"apps"=>
        [{"appId"=>"1",
          "code"=>"BAR",
          "name"=>"MyTestApp",
          "description"=>"",
          "spaceId"=>nil,
          "threadId"=>nil,
          "createdAt"=>"2014-06-02T05:14:05.000Z",
          "creator"=>{"code"=>"user1", "name"=>"user1"},
          "modifiedAt"=>"2014-06-02T05:14:05.000Z",
          "modifier"=>{"code"=>"user1", "name"=>"user1"}},
         {"appId"=>"2",
          "code"=>"FOO",
          "name"=>"TEST",
          "description"=>"",
          "spaceId"=>"123",
          "threadId"=>"456",
          "createdAt"=>"2014-06-03T05:14:05.000Z",
          "creator"=>{"code"=>"user2", "name"=>"user2"},
          "modifiedAt"=>"2014-06-03T05:14:05.000Z",
          "modifier"=>{"code"=>"user2", "name"=>"user2"}}]}
    end

    context 'where params is passed' do
      it do
        client = kintone_client do |stub|
          stub.get('/k/v1/apps.json') do |env|
            expect(params_from_url(env)).to eq({"codes[]"=>"BAR", "name"=>"TEST"})
            expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
            [200, {'Content-Type' => 'json'}, JSON.dump(response)]
          end
        end

        result = client.apps.get(codes: ["FOO", "BAR"], name: "TEST")
        expect(result).to eq response
      end
    end

    context 'where params is not passed' do
      it do
        client = kintone_client do |stub|
          stub.get('/k/v1/apps.json') do |env|
            expect(params_from_url(env)).to be_nil
            expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
            [200, {'Content-Type' => 'json'}, JSON.dump(response)]
          end
        end

        result = client.apps.get
        expect(result).to eq response
      end
    end

    context 'where there is no result' do
      let(:response) do
        {"apps"=>[]}
      end

      it do
        client = kintone_client do |stub|
          stub.get('/k/v1/apps.json') do |env|
            expect(params_from_url(env)).to be_nil
            expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
            [200, {'Content-Type' => 'json'}, JSON.dump(response)]
          end
        end

        result = client.apps.get
        expect(result).to eq response
      end
    end
  end
end
