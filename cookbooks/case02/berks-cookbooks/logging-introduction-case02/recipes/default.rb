#
# Cookbook Name:: case02
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'bootstrap' do
  code <<-EOC
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
  EOC
  command code
  action :run
end

#yumのfastestmirrorとアップデートをする。
yum_package "yum-fastestmirror" do
    action :install
end

execute "yum-update" do
    user "root"
    command "yum -y update"
    action :run
end

include_recipe 'td-agent::default'
