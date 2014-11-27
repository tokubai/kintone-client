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

    subject do
      kintone_client {|stub|
        stub.get('/k/v1/app.json') do |env|
          expect(env.params).to eq({"id"=>"4"})
          expect(env.request_headers['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      }.app.get(id: 4)
    end

    it { is_expected.to eq response }
  end
end
