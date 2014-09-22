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

# プラグイン
execute "elasticsearch-kopf" do
    user "elasticsearch"
    command "plugin -i lmenezes/elasticsearch-kopf"
    action :run
    not_if { File.exist?("/usr/local/elasticsearch-1.3.2/plugins/kopf") }
end
