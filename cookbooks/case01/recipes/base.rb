include_recipe 'build-essential::default'
include_recipe 'apache2::default'
include_recipe 'php::default'
include_recipe 'apache2::mod_php5'
include_recipe 'java::default'

%w{git libcurl-devel}.each do |pkg|
  package pkg do
    action :install
  end
end
