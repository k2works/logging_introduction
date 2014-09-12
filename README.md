ログ収集・可視化入門
===
# 目的
ログ収集・分析環境を構築できるようになる。

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| vagrant   　　　|1.6.3         |             |
| td-agent  　　　|         |             |
| Elasticsearch  　　　|         |             |
| kibana    　　　|         |             |

# 構成
+ [ログ解析からはじめるサービス改善](#1)
+ [ログ収集ミドルウェアFluentd徹底攻略](#2)
+ [Elasticsearch入門](#3)
+ [可視化ツールKibanaスタートガイド](#4)

# 詳細
## <a name="1">ログ解析からはじめるサービス改善</a>
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
<system>ディレクティブ

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

<source>ディレクティブ

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

<match>ディレクティブ

```
# systemにマッチするタグをFluentdの標準出力ログに出力する設定
<match system.*>
  type stdout
</match>
```

<include>ディレクティブ

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
## <a name="4">可視化ツールKibanaスタートガイド/a>

# 参照
+ [サーバ/インフラエンジニア養成読本 ログ収集~可視化編 [現場主導のデータ分析環境を構築!] (Software Design plus)](http://www.amazon.co.jp/%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%8B%E3%82%A2%E9%A4%8A%E6%88%90%E8%AA%AD%E6%9C%AC-%E3%83%AD%E3%82%B0%E5%8F%8E%E9%9B%86~%E5%8F%AF%E8%A6%96%E5%8C%96%E7%B7%A8-%E7%8F%BE%E5%A0%B4%E4%B8%BB%E5%B0%8E%E3%81%AE%E3%83%87%E3%83%BC%E3%82%BF%E5%88%86%E6%9E%90%E7%92%B0%E5%A2%83%E3%82%92%E6%A7%8B%E7%AF%89-Software-Design/dp/4774169838/ref=pd_sim_b_3?ie=UTF8&refRID=17896T8SCN28CX9EAY64)
+ [gihyo coffee sample](https://github.com/suzuken/gihyo-coffee-sample)
+ [treasure-data/chef-td-agent](https://github.com/treasure-data/chef-td-agent)
+ [elasticsearch/cookbook-elasticsearch](https://github.com/elasticsearch/cookbook-elasticsearch.git)
+ [lusis/chef-kibana](https://github.com/lusis/chef-kibana)
+ [fluentd-ui](https://github.com/fluent/fluentd-ui)
+ [td-agentのファイル読み込み設定](http://qiita.com/saicologic/items/8879a277a5c8ead1269f)
