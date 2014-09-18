#
# Cookbook Name:: kibana
# Recipe:: install
#
# Copyright 2013, John E. Vincent
# Copyright 2014, John E. Vincent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

kibana_user 'kibana' do
  name 'kibana'
  group 'kibana'
  home '/opt/kibana'
end

kibana_install 'file' do
  name 'web'
  user 'kibana'
  group 'kibana'
  install_dir '/opt/kibana'
  install_type 'file'
end

kibana_install 'git' do
  name 'kibana-git'
  user 'kibana'
  group 'kibana'
  install_dir '/opt/kibana-git'
  install_type 'git'
end

kibana_web 'kibana_file' do
  type 'apache'
  docroot '/opt/kibana/current'
  listen_port '8080'
end

kibana_web 'kibana_git' do
  type 'nginx'
  docroot '/opt/kibana-git/current'
  es_port '2900'
  listen_port '8081'
end
