include_recipe 'java::default'
include_recipe 'elasticsearch::default'

%w{git}.each do |pkg|
  package pkg do
    action :install
  end
end
