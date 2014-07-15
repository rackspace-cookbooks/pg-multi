#
# Cookbook Name:: pg-multi
# Default:: _debian_slave
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# add .pgpass file to allow pg_basebackup to run without password input
template '/var/lib/postgresql/.pgpass' do
  cookbook 'pg-multi'
  source 'pgpass.erb'
  owner 'postgres'
  group 'postgres'
  mode 0600
  variables(
    username: node['pg-multi']['replication']['user'],
    password: node['pg-multi']['replication']['password']
  )
  not_if { ::File.exists?("/var/lib/postgresql/#{node['postgresql']['version']}/main/recovery.conf") }	
end

# one time sync with database master server
bash 'pull_master_databases' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  service postgresql stop
  sudo -u postgres rm -rf /var/lib/postgresql/#{node['postgresql']['version']}/main
  sudo -u postgres pg_basebackup -h #{node['pg-multi']['master_ip']} -D /var/lib/postgresql/#{node['postgresql']['version']}/main -U repl -w --xlog-method=stream
  EOH
  not_if { ::File.exists?("/var/lib/postgresql/#{node['postgresql']['version']}/main/recovery.conf") }
end

# configure recovery.conf file for replication
template "/var/lib/postgresql/#{node['postgresql']['version']}/main/recovery.conf" do
  cookbook 'pg-multi'
  source 'debian_recovery_conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0644
  variables(
  	cookbook_name: cookbook_name,
    host: node['pg-multi']['master_ip'],
    port: node['postgresql']['config']['port'],
    rep_user: node['pg-multi']['replication']['user'],
    password: node['pg-multi']['replication']['password']
  )
  notifies :restart, "service[postgresql]", :immediately
end
