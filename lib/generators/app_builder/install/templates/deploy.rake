namespace :deploy do
  def deploy_params(env)
    {
      project_name:           "my-project",
      resource_type:          env.resource_type,
      upload_id:              env.upload_id,
      remote_app_home_base:   env.remote_app_home_base,
      resource_host:          env.resource_host,
      resource_user:          env.resource_user,
      resource_ssh_options:   env.resource_ssh_options.symbolize_keys,
      resource_document_root: env.resource_document_root
      optional_parameter:     env,
    }
  end

  def deploy_config
    env = Vars.new(path: "config/deploy/environment.yml", source_type: :git)
    config = AppBuilder::Config.new(**deploy_params(env))

    config.manifest_template_path = File.join(config.archive_path, "config", "deploy", "manifest.yml.erb")
    config.after_archive = [
      proc {
        env.resolve_templates(
          File.join(config.archive_path, "config", "deploy", "templates"),
          File.join(config.archive_path, "config"),
        )
      }
    ]

    config
  end

  desc "Upload builded source and stretcher manifest file."
  task :prepare do
    AppBuilder::Uploader.upload(deploy_config)
  end

  desc "Initialization processing executed on each server"
  task :after_initialize do
    env = Vars.new(path: "config/deploy/environment.yml", name: ENV.fetch("RAILS_ENV"))
    env.resolve_templates("config/deploy/after_initialize", "config")
  end
end
