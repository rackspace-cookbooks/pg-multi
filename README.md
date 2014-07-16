pg-multi
========

Chef wrapper cookbook to create Postgresql Master/Slave Streaming Replication server configuration - creates a master server and read-only slave system(s).
This wrapper should work on all Debian and RHEL platform family OS's.

Utilization
------------

Cookbook works as a wrapper around the community Postgresql cookbook to allow for
the creation of master/slave and master/multi-slave Postgresql systems.

The cookbook utilizes two recipes depending on the server's role.

`pg-master.rb` : sets up a master Postgresql server and creates a replicant users
for along with setting up the authorization within the pg_hba.conf file.

`pg-slave.rb` : sets up a slave Postgresql streaming slave replication server pointing to the master node
definded within attributes. The server is configured by default as read-only.

Attributes
-----------

`['pg-multi']['master']` : sets the IP address that defines the master node

`['pg-multi']['slaves']` : is any array that defines the IP address(es) of
the slave node(s).

`['pg-multi']['replication']['user']` : allows for the setting of a custom name for
the replication user, by default it is set to 'repl'.

`['pg-multi']['replication']['password'] ` : allows for the setting of a custom password for the replication user.

License & Authors
-----------------


