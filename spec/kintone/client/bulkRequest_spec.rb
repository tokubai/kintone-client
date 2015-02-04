# https://cybozudev.zendesk.com/hc/ja/articles/201941814-%E8%A4%87%E6%95%B0%E3%82%A2%E3%83%97%E3%83%AA%E3%81%B8%E3%81%AE%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89%E4%B8%80%E6%8B%AC%E5%87%A6%E7%90%86
describe Kintone::Client do
  describe '複数アプリへのレコード一括処理' do
    let(:request) do
      {"requests"=>
        [{"method"=>"POST",
          "api"=>"/k/v1/record.json",
          "payload"=>
           {"app"=>1972, "record"=>{"文字列__1行"=>{"value"=>"文字列__1行を追加します。"}}}},
         {"method"=>"PUT",
          "api"=>"/k/v1/record.json",
          "payload"=>
           {"app"=>1973,
            "id"=>33,
            "revision"=>2,
            "record"=>{"文字列__1行"=>{"value"=>"文字列__1行を更新します。"}}}},
         {"method"=>"DELETE",
          "api"=>"/k/v1/records.json",
          "payload"=>{"app"=>1974, "ids"=>[10, 11], "revisions"=>[1, 1]}}]}
    end

    let(:unexpanded_request) do
      {"requests"=>
        [{"method"=>"POST",
          "api"=>"/k/v1/record.json",
          "payload"=>
           {"app"=>1972, "record"=>{"文字列__1行"=>"文字列__1行を追加します。"}}},
         {"method"=>"PUT",
          "api"=>"/k/v1/record.json",
          "payload"=>
           {"app"=>1973,
            "id"=>33,
            "revision"=>2,
            "record"=>{"文字列__1行"=>"文字列__1行を更新します。"}}},
         {"method"=>"DELETE",
          "api"=>"/k/v1/records.json",
          "payload"=>{"app"=>1974, "ids"=>[10, 11], "revisions"=>[1, 1]}}]}
    end

    let(:response) do
      {"results"=>[{"id"=>"39", "revision"=>"1"}, {"revision"=>"34"}, {}]}
    end

    it do
      client = kintone_client do |stub|
        stub.post('/k/v1/bulkRequest.json') do |env|
          expect(env[:body]).to eq JSON.dump(request)
          expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          expect(env[:request_headers]['Content-Type']).to eq 'application/json'
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.bulkRequest.post_json(request)
      expect(result).to eq response
    end

    it do
      client = kintone_client do |stub|
        stub.post('/k/v1/bulkRequest.json') do |env|
          expect(env[:body]).to eq JSON.dump(request)
          expect(env[:request_headers]['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
          expect(env[:request_headers]['Content-Type']).to eq 'application/json'
          [200, {'Content-Type' => 'json'}, JSON.dump(response)]
        end
      end

      result = client.bulkRequest.post_json(unexpanded_request)
      expect(result).to eq response
    end
  end
end
