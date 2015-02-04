# https://cybozudev.zendesk.com/hc/ja/articles/202931674-%E3%82%A2%E3%83%97%E3%83%AA%E6%83%85%E5%A0%B1%E3%81%AE%E5%8F%96%E5%BE%97#step1
describe Kintone::Client do
  describe 'アプリ情報の取得(1件)' do
    let(:response) do
      {"id"=>"1",
       "name"=>"全体連絡スペース",
       "defaultThread"=>"3",
       "isPrivate"=>true,
       "creator"=>{"code"=>"tanaka", "name"=>"田中太郎"},
       "modifier"=>{"code"=>"tanaka", "name"=>"田中太郎"},
       "memberCount"=>10,
       "coverType"=>"PRESET",
       "coverKey"=>"GREEN",
       "coverUrl"=>"https://*******/green.jpg",
       "body"=>"<b>全体</b>のスペースです。",
       "useMultiThread"=>true,
       "isGuest"=>false,
       "attachedApps"=>
        [{"threadId"=>"1",
          "appId"=>"1",
          "code"=>"TASK",
          "name"=>"タスク管理",
          "description"=>"タスクを管理するアプリです。",
          "createdAt"=>"2012-02-03T09:22:00Z",
          "creator"=>{"name"=>"佐藤昇", "code"=>"sato"},
          "modifiedAt"=>"2012-04-15T10:08:00Z",
          "modifier"=>{"name"=>"佐藤昇", "code"=>"sato"}},
         {"threadId"=>"3",
          "appId"=>"10",
          "code"=>"",
          "name"=>"アンケートフォーム",
          "description"=>"アンケートアプリです。",
          "createdAt"=>"2012-02-03T09:22:00Z",
          "creator"=>{"name"=>"佐藤昇", "code"=>"sato"},
          "modifiedAt"=>"2012-04-15T10:08:00Z",
          "modifier"=>{"name"=>"佐藤昇", "code"=>"sato"}},
         {"threadId"=>"3",
          "appId"=>"11",
          "code"=>"",
          "name"=>"日報",
          "description"=>"日報アプリです。",
          "createdAt"=>"2012-02-03T09:22:00Z",
          "creator"=>{"name"=>"加藤美咲", "code"=>"kato"},
          "modifiedAt"=>"2012-04-15T10:08:00Z",
          "modifier"=>{"name"=>"加藤美咲", "code"=>"kato"}}]}
    end

    it do
      client = kintone_client do |stub|
        stub.get('/k/v1/space.json') do |env|
          expect(params_from_url(env)).to eq({"id"=>["1"]})
          expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.space.get(id: 1)
      expect(result).to eq response
    end
  end
end
