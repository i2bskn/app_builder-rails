namespace :deploy do
  def build_env
    @build_env ||= AppBuilder::Environment.new(
      ENV.fetch("BILD_ENV", "develop"),
      File.expand_path("../../config/deploy/environment.yml", __dir__),
    )
  end

  def build_config
    @build_config ||= AppBuilder::Config.new(
      upload_id:            build_env[:upload_id],
      remote_app_home_base: build_env[:remote_app_home_base],
    )
  end

  desc "Upload builded source and stretcher manifest file."
  task :upload do
    AppBuilder::Uploader.upload(build_config)
  end
end
