# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "delete_soft/version"

Gem::Specification.new do |s|
  s.name        = "delete_soft"
  s.version     = DeleteSoft::VERSION
  s.authors     = ["Orban Botond"]
  s.email       = ["orbanbotond@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A gem which adds soft delete functionality}
  s.description = %q{A gem which adds soft delete functionality}

  s.rubyforge_project = "delete_soft"

  s.add_dependency('squeel', '>= 0.9.3')

  s.add_development_dependency('sqlite3', ['>= 1.3.4'])
  s.add_development_dependency('activerecord', ['>= 3.1.0'])
  s.add_development_dependency('rake', ['0.9.2'])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
