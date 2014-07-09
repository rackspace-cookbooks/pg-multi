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

include_recipe 'pg-multi::default'

template "#{node['postgresql']['dir']}/pg_hba.conf" do
  source "pg_hba.conf.master.erb"
  owner "postgres"
  group "postgres"
  mode 00600
  notifies change_notify, 'service[postgresql]', :immediately
end

