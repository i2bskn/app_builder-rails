namespace :deploy do
  def deploy_config
    env = AppBuilder::Environment.new("config/deploy/environment.yml")
    config = AppBuilder::Config.new(
      upload_id:            env.upload_id,
      remote_app_home_base: env.remote_app_home_base,
    )

    config.manifest_template_path = File.join(config.archive_path, "config", "deploy", "templates", "manifest.yml.erb")
    config.after_archive = [
      proc {
        env.resolve_templates(
          File.join(config.archive_path, "config", "deploy", "templates"),
          File.join(config.archive_path, "config"),
          excludes: ["manifest.yml"],
        )
      },
    ]

    config
  end

  desc "Upload builded source and stretcher manifest file."
  task :prepare do
    AppBuilder::Uploader.upload(deploy_config)
  end
end
