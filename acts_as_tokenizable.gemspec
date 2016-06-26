# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_tokenizable/version'

Gem::Specification.new do |gem|
  gem.authors = ['Enrique Garcia Cota', 'Francisco Juan']
  gem.email = 'francisco.juan@gmail.com'
  gem.description = 'Make ActiveRecord models easily searchable via tokens.'
  gem.summary = 'Acts as tokenizable'
  gem.homepage = 'https://github.com/fjuan/acts_as_tokenizable'
  gem.license = 'MIT'
  gem.extra_rdoc_files = ['README.rdoc']

  gem.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = 'acts_as_tokenizable'
  gem.require_paths = ['lib']
  gem.version = ActsAsTokenizable::VERSION

  gem.add_runtime_dependency 'activerecord'
  gem.add_runtime_dependency 'babosa'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'pry-byebug'
end
