# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.2'

  spec.name          = 'verge_client'
  spec.version       = File.read(File.expand_path('lib/verge_client/version.rb', __dir__))
                           .match(/VERSION\s*=\s*['"]([^'"]+)['"]/)[1]
  spec.authors       = ['Verge Development']
  spec.email         = ['contact@vergecurrency.com']
  spec.summary       = 'A Verge-Ruby client for making RPC calls to a VERGE daemon.'
  spec.description   = 'This gem provides a Ruby wrapper for RPC interaction with Verge blockchain nodes.'
  spec.homepage      = 'https://vergecurrency.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
