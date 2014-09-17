include_attribute 'java::default'
include_attribute 'elasticsearch::default'

default['java']['jdk_version'] = '7'
default['java']['oracle']['accept_oracle_download_terms'] = 'true'

default.elasticsearch[:version]       = "1.3.2"
default.elasticsearch[:host]          = "http://download.elasticsearch.org"
default.elasticsearch[:repository]    = "elasticsearch/elasticsearch"
default.elasticsearch[:filename]      = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
default.elasticsearch[:download_url]  = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')
