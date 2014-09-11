rvm_ruby "#{node['rvm']['app_version']}" do
  action :install
end

rvm_gemset "#{node['rvm']['app_gemset']}" do
  ruby_string "#{node['rvm']['app_version']}"
  action :create
end

rvm_default_ruby "#{node['rvm']['app_version']}@#{node['rvm']['app_gemset']}" do
  action :create
end

bash "rvmグループにユーザーを追加" do
 code <<-EOH
  usermod -a -G rvm vagrant
  umask 002
  source /etc/profile.d/rvm.sh
  EOH
end
