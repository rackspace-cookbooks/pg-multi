class Chef
  class Provider
    # builds an array of slave systems for use in pg_hba.conf file
    class PgHbaConfig < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        new_resource.slave_ips.each do |slaveip|
          node.default['postgresql']['pg_hba'] << {
            comment: '# authorize slave server',
            type: '#{new_resource.host_type}',
            db: 'replication',
            user: '#{new_resource.repl_user}',
            addr: '#{slaveip}/32',
            method: 'md5'
          }
        end
      end
    end
  end
end
