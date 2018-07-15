module AppBuilder::Generators
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    class_option :resource_type, type: :string, desc: "s3 or http or https"

    def create_environment_yaml
      src = s3? ? "environment_s3.yml" : "environment.yml"
      copy_file src, File.join(deploy_path, "environment.yml")
    end

    def create_manifest_yaml_erb
      copy_file "manifest.yml.erb", File.join(deploy_path, "templates", "manifest.yml.erb")
    end

    def create_deploy_tasks
      src = s3? ? "deploy_s3.rake" : "deploy.rake"
      template src, File.join(tasks_path, "deploy.rake")
    end

    private

      def tasks_path
        "lib/tasks"
      end

      def deploy_path
        "config/deploy"
      end

      def s3?
        resource_type == "s3"
      end

      def resource_type
        options[:resource_type] || "s3"
      end
  end
end
