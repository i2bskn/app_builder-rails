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
      upload_id:            build_env[:upload_id],
      remote_app_home_base: build_env[:remote_app_home_base],
      manifest_template_path: File.join(deploy_path, "templates", "manifest.yml.erb"),
    )
  end

  desc "Upload builded source and stretcher manifest file."
  task :upload do
    AppBuilder::Uploader.upload(build_config)
  end
end
