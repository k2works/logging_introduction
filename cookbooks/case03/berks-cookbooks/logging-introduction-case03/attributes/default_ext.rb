include_attribute 'java::oracle'
include_attribute 'elasticsearch::default'

default['java']['jdk_version'] = '7'

default.elasticsearch[:version]  = "1.3.2"

default.elasticsearch[:download_url]  = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.2.tar.gz"
