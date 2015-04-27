class Chef
  class Provider
    # adds replication user to database
    class PgRepluser < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        execute 'set-replication-user' do # ~FC009
          role_exists = %(psql -c "SELECT rolname FROM pg_roles WHERE rolname='#{new_resource.repl_user}'" | grep #{new_resource.repl_user})
          command %(psql -c "CREATE USER #{new_resource.repl_user} REPLICATION LOGIN ENCRYPTED PASSWORD '#{new_resource.repl_pass}';")
          not_if role_exists,  user: 'postgres'
          user 'postgres'
          sensitive new_resource.sense
          action :run
        end
      end
    end
  end
end
