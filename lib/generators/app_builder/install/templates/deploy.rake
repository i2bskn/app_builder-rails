namespace :deploy do
  def config
    env = AppBuilder::Environment.new("config/deploy/environment.yml")
    config = AppBuilder::Config.new(
      resource_type:          env[:resource_type],
      upload_id:              env[:upload_id],
      remote_app_home_base:   env[:remote_app_home_base],
      resource_host:          env[:resource_host],
      resource_user:          env[:resource_user],
      resource_ssh_options:   env[:resource_ssh_options].symbolize_keys,
      resource_document_root: env[:resource_document_root],
    )

    config.manifest_template_path = File.join(config.archive_path, "config", "deploy", "templates", "manifest.yml.erb")
    config.after_archive = [
      proc {
        env.create_file(
          File.join(config.archive_path, "config", "deploy", "templates", "database.yml.erb"),
          File.join(config.archive_path, "config", "database.yml"),
        )
      },
    ]

    config
  end

  desc "Upload builded source and stretcher manifest file."
  task :upload do
    AppBuilder::Uploader.upload(config)
  end
end
