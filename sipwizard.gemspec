# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sipwizard/version'

Gem::Specification.new do |spec|
  spec.name          = "sipwizard"
  spec.version       = Sipwizard::VERSION
  spec.authors       = ["gregory"]
  spec.email         = ["greg2502@gmail.com"]
  spec.description   = %q{SIP Sorcery ruby client}
  spec.summary       = %q{Wrapper around the sip sorcery api}
  spec.homepage      = "http://github.com/gregory/sipwizard"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rack', "~> 1.5.2"
  spec.add_development_dependency "faraday", '~> 0.8.9'
  spec.add_development_dependency "faraday_middleware", "~> 0.9.0"
end
