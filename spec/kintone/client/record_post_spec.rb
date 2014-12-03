# https://cybozudev.zendesk.com/hc/ja/articles/202166160-%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E7%99%BB%E9%8C%B2-POST-
describe Kintone::Client do
  describe 'レコードの登録（1件）' do
    let(:request) do
      {"app"=>1972,
       "record"=>
        {"文字列__1行"=>{"value"=>"テスト"},
         "文字列__複数行"=>{"value"=>"テスト\nテスト2"},
         "数値"=>{"value"=>"20"},
         "日時"=>{"value"=>"2014-02-16T08:57:00Z"},
         "チェックボックス"=>{"value"=>["sample1", "sample2"]},
         "ユーザー選択"=>{"value"=>[{"code"=>"sato"}]},
         "ドロップダウン"=>{"value"=>"sample1"},
         "リンク_ウェブ"=>{"value"=>"https://www.cybozu.com"},
         "Table"=>{"value"=>[{"value"=>{"テーブル文字列"=>{"value"=>"テスト"}}}]}}}
    end

    let(:unexpanded_request) do
      {"app"=>1972,
       "record"=>
        {"文字列__1行"=>"テスト",
         "文字列__複数行"=>"テスト\nテスト2",
         "数値"=>20,
         "日時"=>"2014-02-16T08:57:00Z",
         "チェックボックス"=>{"value"=>["sample1", "sample2"]},
         "ユーザー選択"=>{"value"=>[{"code"=>"sato"}]},
         "ドロップダウン"=>"sample1",
         "リンク_ウェブ"=>"https://www.cybozu.com",
         "Table"=>{"value"=>[{"value"=>{"テーブル文字列"=>{"value"=>"テスト"}}}]}}}
    end

    let(:response) do
      {"ids"=>["100", "101"], "revisions"=>["1", "1"]}
    end

    it do
      client = kintone_client do |stub|
        stub.post('/k/v1/record.json') do |env|
          expect(env.body).to eq JSON.dump(request)
          expect(env.request_headers['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          expect(env.request_headers['Content-Type']).to eq 'application/json'
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.record.post_json(request)
      expect(result).to eq response
    end

    it do
      client = kintone_client do |stub|
        stub.post('/k/v1/record.json') do |env|
          expect(env.body).to eq JSON.dump(request)
          expect(env.request_headers['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          expect(env.request_headers['Content-Type']).to eq 'application/json'
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.record.post_json(unexpanded_request)
      expect(result).to eq response
    end
  end
end
