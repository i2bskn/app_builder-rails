namespace :deploy do
  def build_config
    env = AppBuilder::Environment.new("config/deploy/environment.yml")
    config = AppBuilder::Config.new(
      upload_id:              env[:upload_id],
      remote_app_home_base:   env[:remote_app_home_base],
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
    AppBuilder::Uploader.upload(build_config)
  end
end
