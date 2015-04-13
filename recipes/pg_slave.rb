# encoding: UTF-8
#
# Cookbook Name:: pg-multi
# Recipe:: pg_slave
#
# Copyright 2014, Rackspace US, Inc.
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

# specific settings for slave postgresql server
node.set['postgresql']['config']['listen_addresses'] = '*'
node.set['postgresql']['config']['wal_level'] = 'hot_standby'
node.set['postgresql']['config']['max_wal_senders'] = 3
node.set['postgresql']['config']['checkpoint_segments'] = 8
node.set['postgresql']['config']['wal_keep_segments'] = 8
node.set['postgresql']['config']['hot_standby'] = 'on'

case node['platform_family']
when 'debian'
  node.set['pg-multi']['host'] = 'hostssl'
when 'redhat'
  node.set['pg-multi']['host'] = 'host'
end

include_recipe 'pg-multi::default'

pg_slave 'default' do
  repl_pass node['pg-multi']['replication']['password']
  master_ip node['pg-multi']['master_ip']
  pg_version node['postgresql']['version']
  host_type node['pg-multi']['host']
end

tag('pg_slave')
