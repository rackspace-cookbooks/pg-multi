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

include_recipe 'pg-multi::default'

unless node.deep_fetch('testkitchen')
  case node['platform_family']
  when 'debian'
    include_recipe 'pg-multi::_debian_slave'
  when 'rhel'
    include_recipe 'pg-multi::_redhat_slave'
  end
end

tag('pg_slave')
