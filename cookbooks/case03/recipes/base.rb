include_recipe 'java::default'
include_recipe 'elasticsearch::default'
include_recipe 'python::default'

%w{git}.each do |pkg|
  package pkg do
    action :install
  end
end

# vagrantユーザーをグループに追加
group "elasticsearch" do
  action :modify
  members "vagrant"
  append true
end

directory "/usr/local/elasticsearch-0.90.12/plugins" do
  owner "elasticsearch"
  group "elasticsearch"
  mode 00775
  action :create
end
