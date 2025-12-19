# -*- encoding: utf-8 -*-
# stub: scan 0.14.2 ruby lib

Gem::Specification.new do |s|
  s.name = "scan".freeze
  s.version = "0.14.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Felix Krause".freeze]
  s.date = "2016-11-21"
  s.description = "The easiest way to run tests of your iOS and Mac app".freeze
  s.email = ["scan@krausefx.com".freeze]
  s.executables = ["scan".freeze]
  s.files = ["bin/scan".freeze]
  s.homepage = "https://fastlane.tools".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.4.5.1".freeze
  s.summary = "The easiest way to run tests of your iOS and Mac app".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<fastlane_core>.freeze, [">= 0.57.0".freeze, "< 1.0.0".freeze])
  s.add_runtime_dependency(%q<xcpretty>.freeze, [">= 0.2.4".freeze, "< 1.0.0".freeze])
  s.add_runtime_dependency(%q<xcpretty-travis-formatter>.freeze, [">= 0.0.3".freeze])
  s.add_runtime_dependency(%q<slack-notifier>.freeze, ["~> 1.3".freeze])
  s.add_runtime_dependency(%q<terminal-table>.freeze, [">= 1.4.5".freeze, "< 2.0.0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<fastlane>.freeze, [">= 1.25.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0".freeze])
  s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.2.3".freeze])
  s.add_development_dependency(%q<pry>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.8.7.4".freeze])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 1.19.0".freeze])
  s.add_development_dependency(%q<coveralls>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.44.0".freeze])
end
