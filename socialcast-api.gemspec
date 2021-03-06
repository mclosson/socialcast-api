# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "socialcast-api/version"

Gem::Specification.new do |s|
  s.name        = "socialcast-api"
  s.version     = Socialcast::Api::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthew Closson", "Sean Cashin"]
  s.email       = ["matthew.closson@gmail.com", "scashin133@gmail.com"]
  s.homepage    = "http://github.com/mclosson/socialcast-api"
  s.summary     = %q{Socialcast API Interface and Examples}
  s.description = %q{Socialcast API Interface and Examples}

  s.rubyforge_project = "scashin133-socialcast-api"
  s.add_runtime_dependency(%q<activeresource>, [">= 2.3"])
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
