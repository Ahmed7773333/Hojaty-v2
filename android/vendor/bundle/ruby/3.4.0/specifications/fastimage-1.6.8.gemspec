# -*- encoding: utf-8 -*-
# stub: fastimage 1.6.8 ruby lib

Gem::Specification.new do |s|
  s.name = "fastimage".freeze
  s.version = "1.6.8".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Stephen Sykes".freeze]
  s.date = "2015-03-05"
  s.description = "FastImage finds the size or type of an image given its uri by fetching as little as needed.".freeze
  s.email = "sdsykes@gmail.com".freeze
  s.extra_rdoc_files = ["README.textile".freeze]
  s.files = ["README.textile".freeze]
  s.homepage = "http://github.com/sdsykes/fastimage".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "2.4.5".freeze
  s.summary = "FastImage - Image info fast".freeze

  s.installed_by_version = "4.0.2".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.3".freeze, ">= 2.3.5".freeze])
  s.add_development_dependency(%q<fakeweb>.freeze, ["~> 1.3".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rdoc>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
end
