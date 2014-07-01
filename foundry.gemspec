# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foundry/version'

Gem::Specification.new do |gem|
  gem.name = 'foundry'
  gem.version = Foundry::VERSION
  gem.authors = ['Jonathan W. Zaleski']
  gem.email = ['JonathanZaleski@gmail.com']
  gem.summary = %{An application configuration gem that aims to keep it simple}
  gem.description = <<-EOL
  Let's face it, there are a number of problems when application/environment
  configuration logic is too tightly coupled with the configuration-data itself.
  This gem aims to keep it simple and fully decouple the two concerns.

  Features:

  * Feature #1
  * Feature #2
  * Feature #3
  EOL
  gem.homepage = 'https://github.com/jzaleski/foundry'
  gem.license = 'MIT'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}) { |file| File.basename(file) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'rake', '~> 10.3'
  gem.add_development_dependency 'rspec', '~> 3.0'
end
