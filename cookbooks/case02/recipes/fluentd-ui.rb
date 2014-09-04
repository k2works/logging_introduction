rvm_gem "fluentd-ui" do
  ruby_string "1.9.3"
  action   :install
  notifies :stop, 'service[td-agent]'
end
=begin
bash "fluentd-ui起動" do
  user 'vagrant'
  group 'vagrant'
  code <<-EOC
   /usr/local/rvm/gems/ruby-1.9.3-p547/bin/fluentd-ui start
  EOC
  creates "/home/vagrant/.fluentd-ui/fluentd-ui.pid"
end
=end
