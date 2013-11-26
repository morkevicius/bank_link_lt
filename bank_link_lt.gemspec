# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bank_link_lt/version'

Gem::Specification.new do |spec|
  spec.name          = "bank_link_lt"
  spec.version       = BankLinkLt::VERSION
  spec.authors       = ["Saulius Morkevicius"]
  spec.email         = ["saulius.m@gmail.com"]
  spec.description   = %q{Lithuanian banklink payment integration}
  spec.summary       = %q{Lithuanian banklink payment integration}
  spec.homepage      = "http://www.wisemonks.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
