default['rvm']['app_version'] = "1.9.3-p547"
default['rvm']['app_gemset'] = "webapp"

default['app_service'] = "fluentd-ui"
default['app_service_rvm_wrapper'] = "/usr/local/rvm/wrappers/default"

default['domain'] = "example.com"
default['passenger']['module_path'] = "/usr/local/rvm/gems/ruby-#{node['rvm']['app_version']}@#{node['rvm']['app_gemset']}/gems/passenger-4.0.50/buildout/apache2"

default['elasticsearch']['plugins']="/usr/local/elasticsearch-1.3.2/plugins"
default['kibana']['webserver'] = 'apache'
