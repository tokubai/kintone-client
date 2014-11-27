# https://cybozudev.zendesk.com/hc/ja/articles/202931674-%E3%82%A2%E3%83%97%E3%83%AA%E6%83%85%E5%A0%B1%E3%81%AE%E5%8F%96%E5%BE%97#step1
describe Kintone::Client do
  describe 'アプリ情報の取得(1件)' do
    let(:response) do
      {"appId"=>"1",
       "code"=>"",
       "name"=>"アプリ",
       "description"=>"よいアプリです",
       "spaceId"=>"2",
       "threadId"=>"3",
       "createdAt"=>"2014-05-02T05:14:05.000Z",
       "creator"=>{"code"=>"", "name"=>""},
       "modifiedAt"=>"2014-06-02T05:14:05.000Z",
       "modifier"=>{"code"=>"jenkins", "name"=>"ボウズマン"}}
    end

    it do
      client = kintone_client do |stub|
        stub.get('/k/v1/app.json') do |env|
          expect(params_from_url(env)).to eq "id=4"
          expect(env.request_headers['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.app.get(id: 4)
      expect(result).to eq response
    end
  end
end
