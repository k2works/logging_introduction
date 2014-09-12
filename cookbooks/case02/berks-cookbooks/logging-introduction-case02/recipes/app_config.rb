#ルートindex.htmlの記述
template "/var/www/html/index.html" do
    source "index.html.erb"
    mode 0644
    variables(
        :message=>node['attrfrom']['message']
    )
end

execute "Enabling site default" do
  user "root"
  cwd "/etc/httpd"
  command "a2ensite default"
  action :run
  notifies :reload, 'service[apache2]'
end
