class Chef
  class Resource
    # builds an array of slave systems for use in pg_hba.conf file
    class PgSlave < Chef::Resource::LWRPBase
      self.resource_name = :pg_slave
      actions :create
      default_action :create

      attribute :cook_book, kind_of: String, default: 'pg-multi'
      attribute :repl_pass, kind_of: String, required: true
      attribute :repl_user, kind_of: String, default: 'repl'
      attribute :master_ip, kind_of: String, required: true
      attribute :pg_version, kind_of: String, required: true
      attribute :pg_port, kind_of: String, default: '5432'
      attribute :host_type, kind_of: String, default: 'host'
      attribute :sense, kind_of: [TrueClass, FalseClass], default: true
    end
  end
end
