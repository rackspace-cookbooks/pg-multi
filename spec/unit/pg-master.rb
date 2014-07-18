# encoding: UTF-8

require 'spec_helper'

describe 'pg-multi::pg-master' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['pg-multi']['slave_ip'] = ['1.2.3.4']
    end.converge(described_recipe)
  end
end
  