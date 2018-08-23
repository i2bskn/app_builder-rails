
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "app_builder/rails/version"

Gem::Specification.new do |spec|
  spec.name          = "app_builder-rails"
  spec.version       = AppBuilder::Rails::VERSION
  spec.authors       = ["i2bskn"]
  spec.email         = ["i2bskn@gmail.com"]

  spec.summary       = %q{Generate application to be deployed and upload to s3 (or deploy server).}
  spec.description   = %q{Generate application to be deployed and upload to s3 (or deploy server).}
  spec.homepage      = "https://github.com/i2bskn/app_builder-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "app_builder", "0.2.9"
  spec.add_dependency "vars", "0.0.4"
  spec.add_dependency "railties"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
end
