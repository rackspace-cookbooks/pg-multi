class Chef
  class Resource
    # builds an array of slave systems for use in pg_hba.conf file
    class PgHbaConfig < Chef::Resource::LWRPBase
      self.resource_name = :pg_hba_config
      actions :create
      default_action :create

      attribute :host_type, kind_of: String, default: 'host'
      attribute :repl_user, kind_of: String, default: 'repl'
      attribute :slave_ips, kind_of: Array, required: true
    end
  end
end
