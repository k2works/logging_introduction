
web_app "my_store" do
  docroot "/var/www/html/my_store"
  server_name "my_store.#{node[:domain]}"
  server_aliases [ "my_store", node[:hostname] ]
  rails_env "production"
end
