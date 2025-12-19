# -*- encoding: utf-8 -*-
# stub: fastlane_core 0.59.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fastlane_core".freeze
  s.version = "0.59.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Felix Krause".freeze]
  s.date = "2016-12-07"
  s.description = "Contains all shared code/dependencies of the fastlane.tools".freeze
  s.email = ["fastlanecore@krausefx.com".freeze]
  s.homepage = "https://fastlane.tools".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.4.5".freeze
  s.summary = "Contains all shared code/dependencies of the fastlane.tools".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<json>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<multi_json>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<highline>.freeze, [">= 1.7.2".freeze])
  s.add_runtime_dependency(%q<colored>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<commander>.freeze, [">= 4.4.0".freeze, "<= 5.0.0".freeze])
  s.add_runtime_dependency(%q<excon>.freeze, [">= 0.45.0".freeze, "< 1.0".freeze])
  s.add_runtime_dependency(%q<rubyzip>.freeze, ["~> 1.1.6".freeze])
  s.add_runtime_dependency(%q<plist>.freeze, [">= 3.1.0".freeze, "< 4.0.0".freeze])
  s.add_runtime_dependency(%q<terminal-table>.freeze, [">= 1.4.5".freeze, "< 2.0.0".freeze])
  s.add_runtime_dependency(%q<gh_inspector>.freeze, [">= 1.0.1".freeze, "< 2.0.0".freeze])
  s.add_runtime_dependency(%q<credentials_manager>.freeze, [">= 0.16.2".freeze, "< 1.0.0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0".freeze])
  s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.2.3".freeze])
  s.add_development_dependency(%q<pry>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.8.7.4".freeze])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 1.19.0".freeze])
  s.add_development_dependency(%q<coveralls>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<fastlane>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<danger>.freeze, [">= 0.1.1".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.44.0".freeze])
end
