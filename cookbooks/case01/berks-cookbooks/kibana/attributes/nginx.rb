# nginx variables.

default['kibana']['nginx']['template'] = 'kibana-nginx.conf.erb'
default['kibana']['nginx']['template_cookbook'] = 'kibana'
default['kibana']['nginx']['enable_default_site'] = false
default['kibana']['nginx']['install_method'] = 'package'
