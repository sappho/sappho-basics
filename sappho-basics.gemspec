# -*- encoding: utf-8 -*-
$: << File.expand_path('../lib', __FILE__)
require 'sappho-basics/version'

# See http://docs.rubygems.org/read/chapter/20#page85 for info on writing gemspecs

Gem::Specification.new do |s|
  s.name        = Sappho::NAME
  s.version     = Sappho::VERSION
  s.authors     = Sappho::AUTHORS
  s.email       = Sappho::EMAILS
  s.homepage    = Sappho::HOMEPAGE
  s.summary     = Sappho::SUMMARY
  s.description = Sappho::DESCRIPTION

  s.rubyforge_project = Sappho::NAME

  s.files         = Dir['lib/**/*']
  s.test_files    = Dir['test/**/*']
  s.executables   = Dir['bin/*'].map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency 'rake', '>= 0.9.2.2'
end
