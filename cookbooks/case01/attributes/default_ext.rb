include_attribute 'td-agent::default'
include_attribute 'kibana::default'

default[:td_agent][:plugins] = [
  "elasticsearch"
]
default['kibana']['webserver'] = 'apache'
