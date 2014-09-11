delayed_job_app_service = node['my_app']

rvm_gem "fluentd-ui" do
  ruby_string "1.9.3"
  action   :install
end

template "/etc/init.d/#{delayed_job_app_service}" do
  source "fluentd-ui_service.erb"
  owner 'root'
  group 'root'
  mode "0755"
end

service "#{delayed_job_app_service}" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end
