# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verge_client/version'

Gem::Specification.new do |spec|
  spec.name          = "verge_client"
  spec.version       = VERGEClient::VERSION
  spec.authors       = ["VERGE"]
  spec.email         = ["vergecurrency@hushmail.com"]
  spec.description   = %q{A VERGE client for ruby. This gem is a ruby wrapper for making remote procedure calls (rpc) to a VERGE daemon (verged.)}
  spec.summary       = %q{VERGEClient is a gem that makes it easy to work with VERGE in ruby.}
  spec.homepage      = "http://vergecurrency.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
end
