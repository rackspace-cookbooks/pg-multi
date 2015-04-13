# encoding: UTF-8
name 'pg-multi'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Postgresql Master/Slave Streaming Replication wrapper cookbook'
source_url 'https://github.com/rackspace-cookbooks/pg-multi'
issues_url 'https://github.com/rackspace-cookbooks/pg-multi/issues'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0' # bump this AFTER release, not in a PR or before

supports 'ubuntu'
supports 'centos'
supports 'redhat'

depends 'postgresql'
depends 'yum'
depends 'apt'
depends 'chef-sugar'
