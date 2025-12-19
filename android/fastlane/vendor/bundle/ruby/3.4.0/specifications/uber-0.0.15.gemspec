# -*- encoding: utf-8 -*-
# stub: uber 0.0.15 ruby lib

Gem::Specification.new do |s|
  s.name = "uber".freeze
  s.version = "0.0.15".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nick Sutterer".freeze]
  s.date = "2015-09-01"
  s.description = "A gem-authoring framework.".freeze
  s.email = ["apotonick@gmail.com".freeze]
  s.homepage = "https://github.com/apotonick/uber".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.4.8".freeze
  s.summary = "Gem-authoring tools like class method inheritance in modules, dynamic options and more.".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, [">= 0.10.1".freeze])
  s.add_development_dependency(%q<minitest>.freeze, [">= 5.0.0".freeze])
end
