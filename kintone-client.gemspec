# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kintone/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'kintone-client'
  spec.version       = Kintone::Client::VERSION
  spec.authors       = ['Genki Sugawara']
  spec.email         = ['sugawara@cookpad.com']
  spec.summary       = %q{It is a simple client of cybozu kintone.}
  spec.description   = %q{It is a simple client of cybozu kintone.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 0.8'
  spec.add_dependency 'faraday_middleware'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'http-dump'
end
