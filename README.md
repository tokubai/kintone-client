# Kintone::Client

It is a simple client of [cybozu kintone](https://kintone.cybozu.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kintone-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kintone-client

## Usage

```ruby
require 'kintone/client'

client = Kintone::Client.new(subdomain: "xxx", login_name: "Genki Sugawara", password: "...")

# https://cybozudev.zendesk.com/hc/ja/articles/202931674-%E3%82%A2%E3%83%97%E3%83%AA%E6%83%85%E5%A0%B1%E3%81%AE%E5%8F%96%E5%BE%97
p client.app.get(id: 211)
p client.records.get(app: 211)

# https://cybozudev.zendesk.com/hc/ja/articles/202166220-%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%A1%E3%83%B3%E3%83%90%E3%83%BC%E3%81%AE%E5%8F%96%E5%BE%97
p client.space.members.get(id: 4)

# `"文字列__1行"=>"テスト"` -> `"文字列__1行"=>{"value"=>"テスト"}`
client.record.post_json(
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
     "Table"=>{"value"=>[{"value"=>{"テーブル文字列"=>{"value"=>"テスト"}}}]}}})
```

## kintone API

* https://cybozudev.zendesk.com/hc/ja/categories/200147600-kintone-API
