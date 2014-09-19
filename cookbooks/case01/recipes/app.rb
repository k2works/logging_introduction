include_recipe 'apache2::default'
include_recipe 'mysql::server'

%w{ImageMagick}.each do |pkg|
  package pkg do
    action :install
  end
end
