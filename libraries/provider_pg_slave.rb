class Chef
  class Provider
    # builds an array of slave systems for use in pg_hba.conf file
    class PgSlave < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        if node['platform_family'] == 'debian'
          data_dir = 'postgresql'
        elsif node['platform_family'] == 'rhel'
          data_dir = 'pgsql'
        end

        service 'pg' do
          case node['platform_family']
          when 'debian'
            service_name 'postgresql'
          when 'rhel'
            service_name "postgresql-#{new_resource.pg_version}"
          end
          supports restart: true
          action :nothing
        end

        # add .pgpass file to allow pg_basebackup to run without password input
        template "/var/lib/#{data_dir}/.pgpass" do # ~FC009
          source 'pgpass.erb'
          owner 'postgres'
          group 'postgres'
          mode 0600
          variables(
            username: new_resource.repl_user,
            password: new_resource.repl_pass
          )
          sensitive new_resource.sense
          not_if { ::File.exist?("/var/lib/#{data_dir}/#{new_resource.pg_version}/main/recovery.conf") }
        end

        # one time sync with database master server
        bash 'pull_master_databases' do
          user 'root'
          cwd '/tmp'
          code <<-EOH
          service postgresql stop
          sudo -u postgres rm -rf /var/lib/#{data_dir}/#{new_resource.pg_version}/main
          sudo -u postgres pg_basebackup -h #{new_resource.master_ip} -D /var/lib/#{data_dir}/#{new_resource.pg_version}/main -U repl -w --xlog-method=stream
          EOH
          not_if { ::File.exist?("/var/lib/#{data_dir}/#{new_resource.pg_version}/main/recovery.conf") }
        end

        # configure recovery.conf file for replication
        template "/var/lib/#{data_dir}/#{new_resource.pg_version}/main/recovery.conf" do
          cookbook new_resource.cook_book
          if new_resource.host_type == 'hostssl'
            source 'ssl_recovery_conf.erb'
          else
            source 'recovery_conf.erb'
          end
          owner 'postgres'
          group 'postgres'
          mode 0644
          variables(
            cookbook_name: cookbook_name,
            host:      new_resource.master_ip,
            port:      new_resource.pg_port,
            rep_user:  new_resource.repl_user,
            password:  new_resource.repl_pass
          )
          sensitive new_resource.sense
          notifies :restart, 'service[pg]', :immediately
        end
      end
    end
  end
end
