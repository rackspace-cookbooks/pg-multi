if defined?(ChefSpec)
  def create_pg_hba_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pg_hba_config, :create, resource_name)
  end

  def create_pg_repluser(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pg_repluser, :create, resource_name)
  end

  def create_pg_slave(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pg_slave, :create, resource_name)
  end
end
