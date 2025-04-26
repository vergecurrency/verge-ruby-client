# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verge_client/version'

Gem::Specification.new do |spec|
  spec.name          = "verge_client"
  spec.version       = VERGEClient::VERSION
  spec.authors       = ["Verge Development"]
  spec.email         = ["contact@vergecurrency.com"]
  spec.description   = %q{A Verge client for ruby. This gem is a ruby wrapper for making remote procedure calls (rpc) to a VERGE daemon (verged.)}
  spec.summary       = %q{Verge-Ruby is a gem that makes it easy to work with Verge in ruby.}
  spec.homepage      = "https://VergeCurrency.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
end
