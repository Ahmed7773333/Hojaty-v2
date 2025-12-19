# -*- encoding: utf-8 -*-
# stub: match 0.11.1 ruby lib

Gem::Specification.new do |s|
  s.name = "match".freeze
  s.version = "0.11.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Felix Krause".freeze]
  s.date = "2016-12-05"
  s.description = "Easily sync your certificates and profiles across your team using git".freeze
  s.email = ["match@krausefx.com".freeze]
  s.executables = ["match".freeze]
  s.files = ["bin/match".freeze]
  s.homepage = "https://fastlane.tools".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.6.6".freeze
  s.summary = "Easily sync your certificates and profiles across your team using git".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<security>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<fastlane_core>.freeze, [">= 0.58.0".freeze, "< 1.0.0".freeze])
  s.add_runtime_dependency(%q<credentials_manager>.freeze, [">= 0.16.2".freeze, "< 1.0.0".freeze])
  s.add_runtime_dependency(%q<spaceship>.freeze, [">= 0.38.5".freeze, "< 1.0.0".freeze])
  s.add_runtime_dependency(%q<sigh>.freeze, [">= 1.12.1".freeze, "< 2.0.0".freeze])
  s.add_runtime_dependency(%q<cert>.freeze, [">= 1.4.4".freeze, "< 2.0.0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0".freeze])
  s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.2.3".freeze])
  s.add_development_dependency(%q<pry>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.8.7.4".freeze])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 1.19.0".freeze])
  s.add_development_dependency(%q<coveralls>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<fastlane>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.44.0".freeze])
end
