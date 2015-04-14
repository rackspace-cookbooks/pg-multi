pg-multi
========

Chef wrapper cookbook to create Postgresql Master/Slave Streaming Replication server configuration - creates a master server and read-only slave system(s). This wrapper should work on all Debian and RHEL platform family OS's that are supported by the community postgresql recipe.

Utilization
------------

This cookbook provides libraries to work along with the community Postgresql cookbook
to allow for the creation of master/slave and master/multi-slave Postgresql systems.

The recipes and libraries provided here are designed for clean initial server setups of this type of systems. They are not designed to do any type of fail-over, this type of automation is better addressed by other tools.

This cookbook is intended as a set of libraries to use with your custom wrapper cookbooks.
The recipes listed here are provided for backwards compatibility was well as example templates
to show how to utilize the underlying libraries.

The three recipes:

`pg_master.rb` : sets up a master Postgresql server and creates a replicant users
for along with setting up the authorization within the pg_hba.conf file.

`pg_slave.rb` : sets up a slave Postgresql streaming slave replication server pointing to the master node defined within attributes. The slave servers are configured by default into read-only mode.

'default.rb' : installs the base Postgresql server provided in the community cookbook.

The three libraries:

`pg_hba_config` - is used to define the setting in the hba.conf file prior to install of the
master server.

`pg_repluser` - is used to setup the replication user on the master server, post server install.

`pg_slave` - is used to setup replication from the slave server side post server install.

Setting PostgreSQL versions
---------------------------

By default the underlying postgresql cookbook sets the version by the OS. This can be
overridden using the attribute:

`['postgresql']['version']`

So for example if you want to have PostgreSQL 9.3 running on your CentOS server (vice the
default of 8.4) you have to set this attribute as a node override:

`node.default['postgresql']['version'] = '9.3'`

Attributes
-----------

`['pg-multi']['master']` : sets the IP address that defines the master node (Required)

`['pg-multi']['slaves']` : is any array that defines the IP address(es) of
the slave node(s). (Required)

`['pg-multi']['replication']['user']` : allows for the setting of a custom name for
the replication user, by default it is set to 'repl'.

`['pg-multi']['replication']['password'] ` : allows for the setting of a custom password for the replication user. (Required)

`['pg-multi']['host']` : sets if SSL is used between master and slave servers for replication. default is 'host' which is no SSL. If the server is a Debian family system it will default to 'hostssl' which enables SSL transport.


License & Authors
-----------------
- Author:: Christopher Coffey (<christopher.coffey@rackspace.com>)

```text

Copyright:: 2014-2015 Rackspace US, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
