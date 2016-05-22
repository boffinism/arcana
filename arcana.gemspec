# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'arcana/version'

Gem::Specification.new do |s|
  s.name        = 'arcana'
  s.version     = Arcana::VERSION
  s.authors     = ['Patrick Gleeson']
  s.email       = ['hello@patrickgleeson.com']
  s.homepage    = 'https://github.com/boffinism/arcana'
  s.summary     = 'A DSL for defining spells and engine for casting them'
  s.description = 'Arcana lets you create Tomes defining the meaning of spell words,
                   and a Demon that parses and executes a given spell'
  s.license     = 'GNU GPL v3'

  s.rubyforge_project = 'arcana'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', '~> 3.0', '>= 3.0.0'
end
