#
# Cookbook Name:: pg-multi
# Recipe:: pg_master
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

# specific settings for master postgresql server
node.set['postgresql']['config']['listen_addresses'] = '*'
node.set['postgresql']['config']['wal_level'] = 'hot_standby'
node.set['postgresql']['config']['max_wal_senders'] = 3
node.set['postgresql']['config']['checkpoint_segments'] = 8
node.set['postgresql']['config']['wal_keep_segments'] = 8

# set SSL usage based on OS support (debian yes, Redhat no)
case node['platform_family']
when 'debian'
  node.set['pg-multi']['host'] = 'hostssl'
else
  node.set['pg-multi']['host'] = 'host'
end

# build array for use in pg_hba.conf file
pghba = []
originpghba = node.default['postgresql']['pg_hba']

node['pg-multi']['slave_ip'].each do |slaveip|
  pghba << {
    comment: '# authorize slave server',
    type: node['pg-multi']['host'],
    db: 'replication',
    user: node['pg-multi']['replication']['user'],
    addr: "#{slaveip}/32",
    method: 'md5'
  }
end

fullset = pghba.zip(originpghba).flatten.compact
node.set['postgresql']['pg_hba'] = fullset

include_recipe 'pg-multi::default'

# adds replication user to database
execute 'set-replication-user' do
  role_exists = %(psql -c "SELECT rolname FROM pg_roles WHERE rolname='#{node['pg-multi']['replication']['user']}'" | grep #{node['pg-multi']['replication']['user']})
  command %Q(psql -c "CREATE USER #{node['pg-multi']['replication']['user']} REPLICATION LOGIN ENCRYPTED PASSWORD '#{node['pg-multi']['replication']['password']}';")
  not_if role_exists,  user: 'postgres'
  user 'postgres'
  action :run
end

tag('pg_master')
