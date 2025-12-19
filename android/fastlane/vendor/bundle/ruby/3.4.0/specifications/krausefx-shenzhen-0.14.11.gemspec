# -*- encoding: utf-8 -*-
# stub: krausefx-shenzhen 0.14.11 ruby lib

Gem::Specification.new do |s|
  s.name = "krausefx-shenzhen".freeze
  s.version = "0.14.11".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mattt Thompson".freeze]
  s.date = "2016-11-10"
  s.description = "CLI for Building & Distributing iOS Apps (.ipa Files)".freeze
  s.email = "m@mattt.me".freeze
  s.executables = ["krausefx-ipa".freeze]
  s.files = ["bin/krausefx-ipa".freeze]
  s.homepage = "http://nomad-cli.com".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.7".freeze
  s.summary = "Shenzhen".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<commander>.freeze, [">= 4.3".freeze, "< 5.0".freeze])
  s.add_runtime_dependency(%q<highline>.freeze, [">= 1.7.2".freeze])
  s.add_runtime_dependency(%q<terminal-table>.freeze, ["~> 1.4.5".freeze])
  s.add_runtime_dependency(%q<json>.freeze, ["~> 1.8".freeze])
  s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.9".freeze])
  s.add_runtime_dependency(%q<faraday_middleware>.freeze, ["~> 0.9".freeze])
  s.add_runtime_dependency(%q<dotenv>.freeze, [">= 0.7".freeze])
  s.add_runtime_dependency(%q<net-sftp>.freeze, ["~> 2.1.2".freeze])
  s.add_runtime_dependency(%q<plist>.freeze, [">= 3.1.0".freeze, "< 4.0.0".freeze])
  s.add_runtime_dependency(%q<rubyzip>.freeze, ["~> 1.1".freeze])
  s.add_runtime_dependency(%q<security>.freeze, ["~> 0.1.3".freeze])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
end
