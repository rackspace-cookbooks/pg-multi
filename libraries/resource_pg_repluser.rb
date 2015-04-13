class Chef
  class Resource
    # adds replication user to database
    class PgRepluser < Chef::Resource::LWRPBase
      self.resource_name = :pg_repluser
      actions :create
      default_action :create

      attribute :repl_pass, kind_of: String, required: true
      attribute :sensitive, kind_of: String, default: 'true'
      attribute :repl_user, kind_of: String, default: 'repl'
    end
  end
end
