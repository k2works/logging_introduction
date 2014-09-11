include_attribute 'mysql::default'
include_attribute 'apache2::default'

default['mysql']['server_root_password'] = ''
