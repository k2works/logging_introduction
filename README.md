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
```
$ cd cookbooks/case02
$ vagrant up
$ vagrant ssh
$ echo '{"message":"Hello World."}' | /usr/lib64/fluent/ruby/bin/fluent-cat debug.test
$ tail /var/log/td-agent/td-agent.log
・・・
4-09-11 09:07:48 +0000 debug.test: {"message":"Hello World."}
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
