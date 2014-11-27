# https://cybozudev.zendesk.com/hc/ja/articles/202331474-%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E5%8F%96%E5%BE%97-GET-#step2
describe Kintone::Client do
  describe 'アプリ情報の取得(1件)' do
    let(:response) do
      {"records"=>
        [{"record_id"=>{"type"=>"RECORD_NUMBER", "value"=>"1"},
          "created_time"=>{"type"=>"CREATED_TIME", "value"=>"2012-02-03T08:50:00Z"},
          "dropdown"=>{"type"=>"DROP_DOWN", "value"=>nil},
          "$revision"=>{"type"=>"__REVISION__", "value"=>"4"}},
         {"record_id"=>{"type"=>"RECORD_NUMBER", "value"=>"2"},
          "created_time"=>{"type"=>"CREATED_TIME", "value"=>"2012-02-03T09:22:00Z"},
          "dropdown"=>{"type"=>"DROP_DOWN", "value"=>nil},
          "$revision"=>{"type"=>"__REVISION__", "value"=>"4"}}]}
    end

    let(:parsed_response) do
      {"records"=>
        [{"record_id"=>"1",
          "created_time"=>"2012-02-03T08:50:00Z",
          "dropdown"=>nil,
          "$revision"=>"4"},
         {"record_id"=>"2",
          "created_time"=>"2012-02-03T09:22:00Z",
          "dropdown"=>nil,
          "$revision"=>"4"}]}
    end

    context 'when there is result' do
      it do
        client = kintone_client do |stub|
          stub.get('/k/v1/record.json') do |env|
            expect(params_from_url(env)).to eq <<-EOS.strip
              app=8&fields[0]=record_id&fields[1]=created_time&fields[2]=dropdown&query=updated_time+>+"2012-02-03T09:00:00+0900"+and+updated_time+<+"2012-02-03T10:00:00+0900"+order+by+record_id+asc+limit+10+offset+20
            EOS
            expect(env.request_headers['X-Cybozu-Authorization']).to eq TEST_AUTH_HEADER
            [200, {'Content-Type' => 'json'}, JSON.dump(response)]
          end
        end

        result = client.record.get(
          app: 8,
          query: 'updated_time > "2012-02-03T09:00:00+0900" and updated_time < "2012-02-03T10:00:00+0900" order by record_id asc limit 10 offset 20',
          fields: ["record_id", "created_time", "dropdown"]
        )

        expect(result).to eq parsed_response
      end
    end
  end
end
