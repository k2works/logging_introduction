
directory "/var/www" do
  owner 'root'
  group 'vagrant'
  mode '0775'
  recursive true
end

web_app "my_store" do
  passenger_module "#{node[:passenger][:module_path]}/mod_passenger.so"
  passenger_root_path "/usr/local/rvm/gems/ruby-#{node['rvm']['app_version']}@#{node['rvm']['app_gemset']}/gems/passenger-4.0.50"
  passenger_default_ruby "/usr/local/rvm/gems/ruby-#{node['rvm']['app_version']}@#{node['rvm']['app_gemset']}/wrappers/ruby"
  docroot "/var/www/my_store/public"
  server_name "my_store.#{node[:domain]}"
  rails_env "production"
end

# ConnectionInfo
mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

# Create a mysql database
mysql_database 'my_store' do
  connection mysql_connection_info
  action :create
end
