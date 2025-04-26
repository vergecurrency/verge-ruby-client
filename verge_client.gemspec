# frozen_string_literal: true
require 'verge_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'verge_client'
  spec.version       = VERGEClient::VERSION
  spec.authors       = ['Verge Development']
  spec.email         = ['contact@vergecurrency.com']
  spec.summary       = 'Verge-Ruby is a gem that makes it easy to work with Verge in ruby.'
  spec.description   = 'A Verge client for Ruby. This gem is a Ruby wrapper for making remote procedure calls (RPC) to a VERGE daemon (verged).'
  spec.homepage      = 'https://vergecurrency.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
end
