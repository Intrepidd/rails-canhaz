# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-canhaz/version'

Gem::Specification.new do |gem|
  gem.name          = "rails-canhaz"
  gem.version       = CanHaz::VERSION
  gem.authors       = ["Intrepidd"]
  gem.email         = ["adrien@siami.fr"]
  gem.description   = 'A simple gem for managing permissions between rails models'
  gem.summary       = 'A simple gem for managing permissions between rails models'
  gem.homepage      = "http://github.com/Intrepidd/rails-canhaz"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activerecord', '>= 3.1.0'
  gem.add_dependency 'rake'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sqlite3'
end
