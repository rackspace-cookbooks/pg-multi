#
# Cookbook Name:: pg-multi
# Default:: pg-master
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

# TODO this needs to loop to pick up multiple slaves...
node.set['postgresql']['pg_hba'] = [{
	:comment => '# slave server using SSL',
	:type => 'hostssl',
	:db => 'replication',
	:user => node['pg-multi']['replication']['user'],
	:addr => "#{node['pg-multi']['slave_ip']}/32",
    :method => 'md5'
    }]

include_recipe 'pg-multi::default'

# adds replication user to database
execute 'set-replication-user' do
  command %Q[psql -c "CREATE USER #{node['pg-multi']['replication']['user']} REPLICATION LOGIN ENCRYPTED PASSWORD '#{node['pg-multi']['replication']['password']}';"]
  not_if %Q[sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{node['pg-multi']['replication']['user']}'"| grep 1 ]
  user 'postgres'
  action :run
end
