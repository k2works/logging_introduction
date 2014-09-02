template "/etc/td-agent/td-agent.conf" do
    source "td-agent.conf.erb"
    mode 0644
    notifies :restart, 'service[td-agent]'
end
