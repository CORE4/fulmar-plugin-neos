namespace :sync do
  namespace :neos do
    config.plugins[:neos][:sync].each do |name, sync_config|
      desc "Sync Neos database and assets from #{name} system"
      task name do
        database_task = config[:database_task] || "update:database:vagrant:from_#{name}"
        Rake::Task[database_task].invoke if Rake::Task.task_defined?(database_task)

        config.set *sync_config[:from].split(':')
        from_hostname = config[:hostname]
        from_path = "#{config[:remote_path]}/Data/Persistent/Resources"
        config.set *sync_config[:to].split(':')
        info 'Syncing assets...'
        remote_shell.run "rsync -aq #{from_hostname}:#{from_path} Data/Persistent"
      end
    end
  end
end
