# encoding: UTF-8
name 'pg-multi'
maintainer 'Christopher Coffey'
maintainer_email 'christopher.coffey@rackspace.com'
license 'Apache 2.0'
description 'Postgresql Master/Slave Streaming Replication wrapper cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'postgresql'
depends 'yum'
depends 'apt'
