ログ収集・可視化入門
===
# 目的
ログ収集・分析環境を構築できるようになる。

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| vagrant   　　　|1.6.3         |             |
| fluentd  　　　 |0.10.5         |             |
| Elasticsearch  |1.3.2         |             |
| JDK            |1.7.0         |             |
| kibana    　　　|3.1.0         |             |

# 構成
+ [ログ解析からはじめるサービス改善](#1)
+ [ログ収集ミドルウェアFluentd徹底攻略](#2)
+ [Elasticsearch入門](#3)
+ [可視化ツールKibanaスタートガイド](#4)

# 詳細
## <a name="1">ログ解析からはじめるサービス改善</a>
### サンプルアプリケーションのインストール
```bash
$ gem install rails -v 4.1.4
$ gem install spree
$ spree install my_store -A
$ cd my_store/
$ bundle install
$ rails g spree:install
```
起動時エラーを回避するため_Gemfile.rock_を編集して_bundle install_

```ruby
    sprockets-rails (2.1.3)
```

店舗画面

_http://localhost:3000/_

管理画面

_http://localhost:3000/admin/_

アカウント: spree@example.com  
パスワード: spree123

### 本番環境へのデプロイ
```bash
$ cd my_store
$ cap production deploy
$ ssh vagrant@192.168.33.10
vagrant@192.168.33.10's password:vagrant
$ cd /var/www/my_store
$ RAILS_ENV=production rake db:seed
$ RAILS_ENV=production rake spree_sample:load
$ touch tmp/restart.txt
```

## <a name="2">ログ収集ミドルウェアFluentd徹底攻略</a>
### td-agent動作確認

```bash
$ cd cookbooks/case02
$ vagrant up
$ vagrant ssh
$ echo '{"message":"Hello World."}' | /usr/lib64/fluent/ruby/bin/fluent-cat debug.test
$ tail /var/log/td-agent/td-agent.log
・・・
4-09-11 09:07:48 +0000 debug.test: {"message":"Hello World."}
```
### fluentd-uiを使う

```bash
$ sudo /etc/init.d/fluentd-ui start
```
_http://192.168.33.10:9292/_にアクセスする。

![001](https://farm6.staticflickr.com/5572/15189089586_fca44d5033.jpg)

アカウント名:admin パスワード:changeme

![002](https://farm6.staticflickr.com/5564/15025542317_80f1b430b8.jpg)

td-agentをセットアップを選択

![003](https://farm4.staticflickr.com/3886/15025326789_a3c2190afa.jpg)

作成

![004](https://farm4.staticflickr.com/3905/15025326899_562b7ae735.jpg)


### クックブックの構成

_cookbooks/case02/Vagrantfile_

```ruby
chef.run_list = %w[
  recipe[logging-introduction-case02::default]
  recipe[logging-introduction-case02::base]
  recipe[logging-introduction-case02::app]
  recipe[logging-introduction-case02::app_config]
  recipe[logging-introduction-case02::rvm_config]
  recipe[logging-introduction-case02::fluentd_config]
  recipe[logging-introduction-case02::fluentd-ui]
]
```

#### cookbooks/case02/recipes/default.rb
仮想マシン共通セットアップ

#### cookbooks/case02/recipes/base.rb
td-agentインストール  
その他必要なパッケージ

#### cookbooks/case02/recipes/app.rb
Webサーバー・DBサーバーインストール

#### cookbooks/case02/recipes/app_config.rb
Webサーバー・DBサーバー設定

#### cookbooks/case02/recipes/rvm_config.rb
rvm設定

#### cookbooks/case02/recipes/fluentd_config.rb
td-agent設定

#### cookbooks/case02/recipes/fluentd-ui.rb
fluentd-uiインストール・デーモン設定

### Fluentdの設定ファイル
systemディレクティブ

```
<system>
 # ログ出力レベルを設定(trace, debug,info,warn,error,fatal)
 log_level info
 # 連続した同一エラー出力を抑制する
 suppress_repeated_stacktrace true
 # 指定時間内の同一エラー出力を制御する
 emit_error_log_interval              60s
 # 起動時に設定ファイルの標準ログ出力を制御する
 suppress_config_dump             true
</system>
```

sourceディレクティブ

```
<source>
  # プラグインを指定
  type tail
  # 読み込むログファイルを指定
  path /var/log/messages
  # タグ指定
  ## Fluentdプラグイン間でメッセージをルーティングする際の識別に利用
  tag system.messages
  # ログフォーマット定義
  ## 正規表現,apache,apache2,nginx,syslog,tsv,csv,ltsv,json,
  ## none(行全体をmessageキーの値として取り込む場合)のいづれかを指定
  format syslog
  time_format %b %d %H:%M:%S
  pos_file /tmp/fluentd--1410421801.pos
</source>
```

matchディレクティブ

```
# systemにマッチするタグをFluentdの標準出力ログに出力する設定
<match system.*>
  type stdout
</match>
```

includeディレクティブ

```
# 絶対パスでの記述
include /path/to/config.conf

# 相対パスで記述する場合には、呼び出し元の設定ファイルが
# 置かれたディレクトリを起点としてファイルを読み込みます
include extra.conf

# 複数ファイルの読み込みはワイルドカード指定を使います
include config.d/*.conf

# 外部URLから設定を読み込みます
include http://example.com/fluentd.conf
```

## <a name="3">Elasticsearch入門</a>
### 起動の確認
```bash
$ cd cookbooks/case03
$ vagrant up
$ vagrant ssh
$ $ curl -XGET http://localhost:9200/
{
  "ok" : true,
  "status" : 200,
  "name" : "case01",
  "version" : {
    "number" : "0.90.12",
    "build_hash" : "26feed79983063ae83bfa11bd4ce214b1f45c884",
    "build_timestamp" : "2014-02-25T15:38:23Z",
    "build_snapshot" : false,
    "lucene_version" : "4.6"
  },
  "tagline" : "You Know, for Search"
}
```
### クラスタの状態を確認
```bash
$ curl -XGET http://localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0
}
```
### 設定
#### 環境変数

_cookbooks/case03/berks-cookbooks/elasticsearch/templates/default/elasticsearch-env.sh.erb_  

#### システム設定
ファイルディスクリプタ
```bash
$ cat /etc/security/limits.d/10-elasticsearch.conf
elasticsearch     -    nofile    64000
elasticsearch     -    memlock   unlimited
```

#### Elasticsearchの設定

_cookbooks/case03/berks-cookbooks/elasticsearch/templates/default/elasticsearch.yml.erb_


### インデックスとデータの操作
インデックスの作成

```bash
$ curl -XPOST http://localhost:9200/test_index
{"ok":true,"acknowledged":true}
```

データの取り込み

```bash
$ curl -XPUT http://localhost:9200/test_index/apache_log/1 -d '
{
"host":"localhost",
"timestamp": "06/May/2014:06:11:48 +0000",
"verb": "GET",
"request": "/category/finace",
"httpversion": "1.1",
"response": "200",
"bytes": "51"
}
'
{"ok":true,"_index":"test_index","_type":"apache_log","_id":"1","_version":1}
```

データの削除

```bash
$ curl -XDELETE http://localhost:9200/test_index/apache_log/1
{"ok":true,"found":true,"_index":"test_index","_type":"apache_log","_id":"1","_version":2}
```

### 検索

全件検索

```bash
$ curl -XGET http://localhost:9200/test_index/_search -d '
> {
> "query" : {
> "match_all" : {}
> }
> }
> '
{"took":65,"timed_out":false,"_shards":{"total":5,"successful":5,"failed":0},"hits":{"total":1,"max_score":1.0,"hits":[{"_index":"test_index","_type":"apache_log","_id":"1","_score":1.0, "_source" :
{
"host":"localhost",
"timestamp": "06/May/2014:06:11:48 +0000",
"verb": "GET",
"request": "/category/finace",
"httpversion": "1.1",
"response": "200",
"bytes": "51"
}
}]}}
```

query string query

```bash
$ curl -XGET http://localhost:9200/test_index/_search -d '
> {
> "query" : {
> "query_string" : {
> "query" : "request:/category/finace AND response:200"
> }
> }
> }
> '
{"took":72,"timed_out":false,"_shards":{"total":5,"successful":5,"failed":0},"hits":{"total":1,"max_score":1.0253175,"hits":[{"_index":"test_index","_type":"apache_log","_id":"1","_score":1.0253175, "_source" :
{
"host":"localhost",
"timestamp": "06/May/2014:06:11:48 +0000",
"verb": "GET",
"request": "/category/finace",
"httpversion": "1.1",
"response": "200",
"bytes": "51"
}
}]}}
```

ファセット

```bash
$ curl -XGET http://localhost:9200/test_index/_search -d '
> {
> "query" : {
> "match_all" : {}
> },
> "facets" : {
> "request_facet" : {
> "terms" : {
> "field" : "request",
> "size" : 10
> }
> }
> }
> }
> '
{"took":26,"timed_out":false,"_shards":{"total":5,"successful":5,"failed":0},"hits":{"total":1,"max_score":1.0,"hits":[{"_index":"test_index","_type":"apache_log","_id":"1","_score":1.0, "_source" :
{
"host":"localhost",
"timestamp": "06/May/2014:06:11:48 +0000",
"verb": "GET",
"request": "/category/finace",
"httpversion": "1.1",
"response": "200",
"bytes": "51"
}
}]},"facets":{"request_facet":{"_type":"terms","missing":0,"total":2,"other":0,"terms":[{"term":"finace","count":1},{"term":"category","count":1}]}}}
```

ファセットタイプ

| タイプ     | 説明    |
|:---------------|:-------------|
| terms     | インデックスお値ごとにドキュメント数を集計       |
| range     | インデックスの値を元に指定された範囲ごとにドキュメント数を集計     |
| histogram | インデックスの数値データを元に指定された間隔ごとにドキュメント数を集計       |
| statistical    |  インデックスの数値フィールドの統計値[min,max,ドキュメント数]       |
| query     | 指定されたクエリのドキュメント数を集計       |

インデックスの削除

```bash
$ curl -XDELETE http://localhost:9200/test_index
{"ok":true,"acknowledged":true}
```

### マッピング定義

マッピングの指定

```bash
$ curl -XPUT http://localhost:9200/test_index -d '
> {
> "mappings": {
> "apache_log": {
> "properties": {
> "request": {
> "type": "string",
> "index": "not_analyzed"
> }
> }
> }
> }
> }
> '
```

マッピングの確認

```bash
$ curl -XGET http://localhost:9200/test_index/_mapping
{"test_index":{"apache_log":{"properties":{"request":{"type":"string","index":"not_analyzed","norms":{"enabled":false},"index_options":"docs"}}}}}
```

## インデックス管理ツールとプラグイン
### Curator
インストール

```bash
$ sudo pip install elasticsearch-curator
$ sudo pip install argparse
```
バージョンの確認

```bash
$ curator -v
curator 1.2.2
```
日数を指定した削除

```bash
$ curator --host localhost delete --older-than 30
```
容量を指定した削除

```bash
$ curator --host localhost delete --disk-space 1024
```
日数を指定したクローズ

```bash
$ curator --host localhost close --older-than 7
```
Bloom filter無効化

```bash
$ curator --host localhost bloom --older-than 2
```
日数を指定したオプティマイズ

```bash
$ curator --host localhost optimize --older-than 2
```

### プラグイン
elasticserch-head

```bash
$ plugin -i mobz/elasticsearch-head
```

_http://192.168.33.10:9200/_plugin/head/_

![005](https://farm6.staticflickr.com/5596/15264409122_dbaa032458.jpg)

elasticsearch-kopf

```bash
$ plugin -i lmenezes/elasticsearch-kopf
```

_http://192.168.33.10:9200/_plugin/kopf/_

![006](https://farm4.staticflickr.com/3874/15264798885_84b358b6ac.jpg)

marvel

```bash
$ plugin -i elasticsearch/marvel/latest
$ sudo /etc/init.d/elasticsearch restart
```

_http://192.168.33.10:9200/_plugin/marvel/_

![007](https://farm4.staticflickr.com/3882/15078228837_0a95309eec.jpg)


## <a name="4">可視化ツールKibanaスタートガイド</a>
サンプルデータのインポート  
[サーバ/インフラエンジニア養成読本 Kibanaテストデータ](https://github.com/harukasan/kibana-testdata)を参考にローカルでデータを作成したデータを登録する。
```bash
$ curl -s -XPOST 192.168.33.10:9200/_bulk --data-binary @events.json > /dev/null
```
以下のページをブラウザで指定する。

_http://192.168.33.10/#/dashboard/file/guided.json_

![008](https://farm6.staticflickr.com/5569/15089114529_7fe1046b59.jpg)

# 参照
+ [サーバ/インフラエンジニア養成読本 ログ収集~可視化編 [現場主導のデータ分析環境を構築!] (Software Design plus)](http://www.amazon.co.jp/%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%8B%E3%82%A2%E9%A4%8A%E6%88%90%E8%AA%AD%E6%9C%AC-%E3%83%AD%E3%82%B0%E5%8F%8E%E9%9B%86~%E5%8F%AF%E8%A6%96%E5%8C%96%E7%B7%A8-%E7%8F%BE%E5%A0%B4%E4%B8%BB%E5%B0%8E%E3%81%AE%E3%83%87%E3%83%BC%E3%82%BF%E5%88%86%E6%9E%90%E7%92%B0%E5%A2%83%E3%82%92%E6%A7%8B%E7%AF%89-Software-Design/dp/4774169838/ref=pd_sim_b_3?ie=UTF8&refRID=17896T8SCN28CX9EAY64)
+ [gihyo coffee sample](https://github.com/suzuken/gihyo-coffee-sample)
+ [spree/spree](https://github.com/spree/spree)
+ [Phusion Passenger users guide, Apache version](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#_installing_or_upgrading_on_red_hat_fedora_centos_or_scientificlinux)
+ [Asset Path Error in Spree / Ruby on Rails](http://stackoverflow.com/questions/25633822/asset-path-error-in-spree-ruby-on-rails)
+ [treasure-data/chef-td-agent](https://github.com/treasure-data/chef-td-agent)
+ [elasticsearch/cookbook-elasticsearch](https://github.com/elasticsearch/cookbook-elasticsearch.git)
+ [lusis/chef-kibana](https://github.com/lusis/chef-kibana)
+ [fluentd-ui](https://github.com/fluent/fluentd-ui)
+ [td-agentのファイル読み込み設定](http://qiita.com/saicologic/items/8879a277a5c8ead1269f)
+ [サーバ/インフラエンジニア養成読本 Kibanaテストデータ](https://github.com/harukasan/kibana-testdata)
+ [Kibana](http://www.elasticsearch.org/overview/kibana/)
