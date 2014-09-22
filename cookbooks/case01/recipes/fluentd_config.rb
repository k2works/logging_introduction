# td-agentのファイル読み込み設定
# System関連
%w{
  /var/log/messages
  /var/log/secure
}.each do |file_path|
  file file_path do
    group "td-agent"
    mode '0650'
    only_if { ::File.exists?(file_path) }
  end
end

# Webサーバ関連
%w{
  /var/log/httpd
}.each do |dir_path|
  directory dir_path do
    group "td-agent"
    mode '0650'
    only_if { ::File.exists?(dir_path) }
  end
end

# DBサーバ関連
group "mysql" do
  action :modify
  members "td-agent"
  append true
end

# 設定ファイル
template "/etc/td-agent/td-agent.conf" do
  source "td-agent.conf.erb"
  owner 'root'
  group 'root'
  mode "0755"
end

# プラグインインストール
execute "fluent-plugin-elasticsearch" do
    user "vagrant"
    command "sudo /usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-elasticsearch"
    action :run
end
