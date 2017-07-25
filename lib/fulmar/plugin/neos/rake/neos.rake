namespace :sync do
  namespace :neos do
    config.plugins[:neos][:sync].each do |name, sync_config|
      desc "Sync Neos database and assets from #{name} system"
      task name do
        to_environment = sync_config[:to].split(':').first
        database_task = sync_config[:database_task] || "update:database:#{to_environment}:from_#{name}"
        Rake::Task[database_task].invoke if Rake::Task.task_defined?(database_task)

        config.set *sync_config[:from].split(':').map(&:to_sym)
        from_hostname = config[:hostname]
        current = config[:type] == 'rsync_with_versions' ? '/current' : ''
        from_path = "#{config[:remote_path]}#{current}/Data/Persistent/Resources"
        config.set *sync_config[:to].split(':').map(&:to_sym)
        info 'Syncing assets...'
        remote_shell.run "rsync -aq #{from_hostname}:#{from_path} Data/Persistent"
        info 'Publishing assets...'
        remote_shell.run './flow resource:publish'
      end
    end
  end
end
