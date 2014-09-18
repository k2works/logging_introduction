include_recipe 'java::oracle'
include_recipe 'elasticsearch::default'

# vagrantユーザーをグループに追加
group "elasticsearch" do
  action :modify
  members "vagrant"
  append true
end

directory node['elasticsearch']['plugins'] do
  owner "elasticsearch"
  group "elasticsearch"
  mode 00775
  action :create
end
