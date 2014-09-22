app_service = node['app_service']

rvm_gem "fluentd-ui" do
  ruby_string "#{node['rvm']['app_version']}@#{node['rvm']['app_gemset']}"
  action   :install
end

template "/etc/init.d/#{app_service}" do
  source "fluentd-ui_service.erb"
  owner 'root'
  group 'root'
  mode "0755"
end

service "#{app_service}" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end
