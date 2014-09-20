
directory "/var/www" do
  owner 'root'
  group 'vagrant'
  mode '0775'
  recursive true
end

web_app "my_store" do
  passenger_module "#{node[:passenger][:module_path]}/mod_passenger.so"
  passenger_root "/usr/local/rvm/gems/ruby-1.9.3-p547@webapp/gems/passenger-4.0.50"
  passenger_default_ruby "/usr/local/rvm/gems/ruby-1.9.3-p547@webapp/wrappers/ruby"
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
