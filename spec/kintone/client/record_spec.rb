# https://cybozudev.zendesk.com/hc/ja/articles/202331474-%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E5%8F%96%E5%BE%97-GET-#step1
describe Kintone::Client do
  describe 'アプリ情報の取得(1件)' do
    let(:response) do
      {"record"=>
        {"文字列__1行"=>{"type"=>"SINGLE_LINE_TEXT", "value"=>"テスト"},
         "文字列__複数行"=>{"type"=>"MULTI_LINE_TEXT", "value"=>"テスト\nテスト2"},
         "リッチエディター"=>
          {"type"=>"RICH_TEXT",
           "value"=>"<span style=\"color: rgb(0,0,255);\">テスト</span>"},
         "$id"=>{"type"=>"__ID__", "value"=>"1"},
         "$revision"=>{"type"=>"__REVISION__", "value"=>"7"},
         "日付"=>{"type"=>"DATE", "value"=>"2014-02-16"},
         "数値"=>{"type"=>"NUMBER", "value"=>"20"},
         "Table"=>
          {"type"=>"SUBTABLE",
           "value"=>
            [{"id"=>"33347",
              "value"=>
               {"ルックアップ"=>{"type"=>"SINGLE_LINE_TEXT", "value"=>""},
                "テーブル文字列"=>{"type"=>"SINGLE_LINE_TEXT", "value"=>"テスト"},
                "テーブル数値"=>{"type"=>"NUMBER", "value"=>"1000"}}},
             {"id"=>"33354",
              "value"=>
               {"ルックアップ"=>{"type"=>"SINGLE_LINE_TEXT", "value"=>""},
                "テーブル文字列"=>{"type"=>"SINGLE_LINE_TEXT", "value"=>"テスト2"},
                "テーブル数値"=>{"type"=>"NUMBER", "value"=>"2000"}}}]},
         "日時"=>{"type"=>"DATETIME", "value"=>"2014-02-16T08:57:00Z"},
         "ユーザー選択"=>
          {"type"=>"USER_SELECT", "value"=>[{"code"=>"sato", "name"=>"佐藤　昇"}]},
         "時刻"=>{"type"=>"TIME", "value"=>"17:57"},
         "作成日時"=>{"type"=>"CREATED_TIME", "value"=>"2014-02-16T08:59:00Z"},
         "チェックボックス"=>{"type"=>"CHECK_BOX", "value"=>["sample1", "sample2"]},
         "複数選択"=>{"type"=>"MULTI_SELECT", "value"=>["sample1", "sample2"]},
         "更新日時"=>{"type"=>"UPDATED_TIME", "value"=>"2014-02-17T02:35:00Z"},
         "作成者"=>{"type"=>"CREATOR", "value"=>{"code"=>"sato", "name"=>"佐藤　昇"}},
         "更新者"=>{"type"=>"MODIFIER", "value"=>{"code"=>"sato", "name"=>"佐藤　昇"}},
         "レコード番号"=>{"type"=>"RECORD_NUMBER", "value"=>"1"},
         "ドロップダウン"=>{"type"=>"DROP_DOWN", "value"=>"sample2"},
         "リンク_ウェブ"=>{"type"=>"LINK", "value"=>"https://www.cybozu.com"},
         "添付ファイル"=>
          {"type"=>"FILE",
           "value"=>
            [{"contentType"=>"image/png",
              "fileKey"=>"20140216085901A05579B4196F4968AE26262EE889BD58086",
              "name"=>"2014-01-30_No-0001.png",
              "size"=>"30536"}]}}}
    end

    let(:parsed_response) do
      {"record"=>
        {"文字列__1行"=>"テスト",
         "文字列__複数行"=>"テスト\nテスト2",
         "リッチエディター"=>"<span style=\"color: rgb(0,0,255);\">テスト</span>",
         "$id"=>"1",
         "$revision"=>"7",
         "日付"=>"2014-02-16",
         "数値"=>"20",
         "Table"=>
          {"33347"=>{"ルックアップ"=>"", "テーブル文字列"=>"テスト", "テーブル数値"=>"1000"},
           "33354"=>{"ルックアップ"=>"", "テーブル文字列"=>"テスト2", "テーブル数値"=>"2000"}},
         "日時"=>"2014-02-16T08:57:00Z",
         "ユーザー選択"=>[{"code"=>"sato", "name"=>"佐藤　昇"}],
         "時刻"=>"17:57",
         "作成日時"=>"2014-02-16T08:59:00Z",
         "チェックボックス"=>["sample1", "sample2"],
         "複数選択"=>["sample1", "sample2"],
         "更新日時"=>"2014-02-17T02:35:00Z",
         "作成者"=>{"code"=>"sato", "name"=>"佐藤　昇"},
         "更新者"=>{"code"=>"sato", "name"=>"佐藤　昇"},
         "レコード番号"=>"1",
         "ドロップダウン"=>"sample2",
         "リンク_ウェブ"=>"https://www.cybozu.com",
         "添付ファイル"=>
          [{"contentType"=>"image/png",
            "fileKey"=>"20140216085901A05579B4196F4968AE26262EE889BD58086",
            "name"=>"2014-01-30_No-0001.png",
            "size"=>"30536"}]}}
    end

    it do
      client = kintone_client do |stub|
        stub.get('/k/v1/record.json') do |env|
          expect(params_from_url(env)).to eq({"app"=>"8", "id"=>"100"})
          expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.record.get(app: 8, id: 100)
      expect(result).to eq parsed_response
    end
  end
end
