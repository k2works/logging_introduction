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

# 設定ファイル
template "/etc/td-agent/td-agent.conf" do
  source "td-agent.conf.erb"
  owner 'root'
  group 'root'
  mode "0755"
end
