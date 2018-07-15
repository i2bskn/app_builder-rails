namespace :deploy do
  def deploy_path
    File.expand_path("../../config/deploy", __dir__)
  end

  def build_env
    @build_env ||= AppBuilder::Environment.new(
      ENV.fetch("BILD_ENV", "develop"),
      File.join(deploy_path, "environment.yml"),
    )
  end

  def build_config
    @build_config ||= AppBuilder::Config.new(
      resource_type:          build_env[:resource_type],
      upload_id:              build_env[:upload_id],
      remote_app_home_base:   build_env[:remote_app_home_base],
      resource_host:          build_env[:resource_host],
      resource_user:          build_env[:resource_user],
      resource_ssh_options:   build_env[:resource_ssh_options].symbolize_keys,
      resource_document_root: build_env[:resource_document_root],
      manifest_template_path: File.join(deploy_path, "templates", "manifest.yml.erb"),
    )
  end

  desc "Upload builded source and stretcher manifest file."
  task :upload do
    AppBuilder::Uploader.upload(build_config)
  end
end
