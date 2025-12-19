# -*- encoding: utf-8 -*-
# stub: screengrab 0.5.6 ruby lib

Gem::Specification.new do |s|
  s.name = "screengrab".freeze
  s.version = "0.5.6".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrea Falcone".freeze, "Michael Furtak".freeze]
  s.date = "2016-11-15"
  s.description = "Automated localized screenshots of your Android app on every device".freeze
  s.email = ["screengrab@fabric.io".freeze]
  s.executables = ["screengrab".freeze]
  s.files = ["bin/screengrab".freeze]
  s.homepage = "https://fastlane.tools".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.4.5.1".freeze
  s.summary = "Automated localized screenshots of your Android app on every device".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<fastlane_core>.freeze, [">= 0.55.0".freeze, "< 1.0.0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<coveralls>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<fastlane>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<activesupport>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<pry>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0".freeze])
  s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.2.3".freeze])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.8.7.4".freeze])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 1.19.0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.44.0".freeze])
end
