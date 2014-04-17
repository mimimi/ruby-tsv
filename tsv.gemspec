# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tsv/version'

Gem::Specification.new do |spec|
  spec.name          = "tsv"
  spec.version       = TSV::VERSION
  spec.authors       = ["Dmytro Soltys", "Alexander Rozumiy"]
  spec.email         = ["soap@slotos.net", "brain-geek@yandex.ua"]
  spec.description   = %q{Streamed TSV parser}
  spec.summary       = %q{Provides a simple parser for standard compliant and not so (missing header line) TSV files}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
