# encoding: UTF-8

require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'centos' => ['6.5']	
}

describe 'pg-multi::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['postgresql']['password'] = 'passwurd'
      node.set['postgresql']['version'] = ['9.3']
    end.converge(described_recipe)
  end

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        it 'includes the `postgresql::server` recipe' do
          expect(chef_run).to include_recipe('postgresql::server')
        end
      end
    end
  end
end