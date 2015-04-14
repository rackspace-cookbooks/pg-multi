# encoding: UTF-8
#
# Cookbook Name:: pg-multi
# Recipe:: pg_master
#
# Copyright 2015, Rackspace US, Inc.
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

include_recipe 'chef-sugar'

# specific settings for master postgresql server
node.set['postgresql']['config']['listen_addresses'] = '*'
node.set['postgresql']['config']['wal_level'] = 'hot_standby'
node.set['postgresql']['config']['max_wal_senders'] = 3
node.set['postgresql']['config']['checkpoint_segments'] = 8
node.set['postgresql']['config']['wal_keep_segments'] = 8

# since debian OS families can do ssl by default enable it, otherwise non-ssl connections
case node['platform_family']
when 'debian'
  node.set['pg-multi']['host'] = 'hostssl'
when 'redhat'
  node.set['pg-multi']['host'] = 'host'
end

# Used to define the hda.conf file prior to install of main postgresql service
pg_hba_config 'default' do
  host_type node['pg-multi']['host']
  slave_ips node['pg-multi']['slave_ip']
end

include_recipe 'pg-multi::default'

# Setup replication user
pg_repluser 'default' do
  repl_pass node['pg-multi']['replication']['password']
end

tag('pg_master')
