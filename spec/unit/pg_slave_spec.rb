# encoding: UTF-8
require 'spec_helper'

describe 'pg-multi::pg_slave' do
  before do
    allow(::File).to receive(:symlink?).and_return(false)
  end

  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'centos' => ['6.5']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node.set['postgresql']['password']['postgres'] = 'test123'
            node.set['postgresql']['version'] = '9.3'
            node.set['pg-multi']['replication']['user'] = 'repl'
            node.set['pg-multi']['replication']['password'] = 'useagudpasswd'
          end.converge(described_recipe)
        end

        it 'includes pg-multi::default' do
          expect(chef_run).to include_recipe('pg-multi::default')
        end
      end
    end
  end

  uplats = {
    'ubuntu' => ['12.04', '14.04']
  }

  uplats.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:uplats_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node.set['postgresql']['password']['postgres'] = 'test123'
            node.set['postgresql']['version'] = '9.3'
            node.set['pg-multi']['replication']['user'] = 'repl'
            node.set['pg-multi']['replication']['password'] = 'useagudpasswd'
          end.converge(described_recipe)
        end

        it 'includes pg-multi::_debian_slave' do
          expect(uplats_run).to include_recipe('pg-multi::_debian_slave')
        end

        it 'creates .pgpass file' do
          expect(uplats_run).to create_template('/var/lib/postgresql/.pgpass').with(
            user: 'postgres',
            group: 'postgres',
            mode: 0600
          )
        end

        it 'runs a bash script to pull master databases' do
          expect(uplats_run).to run_bash('pull_master_databases')
        end

        it 'creates recovery.conf file' do
          expect(uplats_run).to create_template('/var/lib/postgresql/9.3/main/recovery.conf').with(
            user: 'postgres',
            group: 'postgres',
            mode: 0644
          )
        end
      end
    end
  end
  cplats = {
    'centos' => ['6.5']
  }

  cplats.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:cplats_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node.set['postgresql']['password']['postgres'] = 'test123'
            node.set['postgresql']['version'] = '9.3'
            node.set['pg-multi']['replication']['user'] = 'repl'
            node.set['pg-multi']['replication']['password'] = 'useagudpasswd'
          end.converge(described_recipe)
        end

        it 'includes pg-multi::_redhat_slave' do
          expect(cplats_run).to include_recipe('pg-multi::_redhat_slave')
        end

        it 'creates .pgpass file' do
          expect(cplats_run).to create_template('/var/lib/pgsql/.pgpass').with(
            user: 'postgres',
            group: 'postgres',
            mode: 0600
          )
        end

        it 'stops postgresl-9.3 service' do
          expect(cplats_run).to stop_service('postgresql')
        end

        it 'creates recovery.conf file' do
          expect(cplats_run).to create_template('/var/lib/pgsql/9.3/data/recovery.conf').with(
            user: 'postgres',
            group: 'postgres'
          )
        end
      end
    end
  end
end
