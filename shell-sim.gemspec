lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shell-sim/version'

Gem::Specification.new do |gem|
  gem.name           =  'shell-sim'
  gem.version        =  ShellSim::Version
  gem.date           =  '2015-09-19'
  gem.summary        =  'Simulates a *nix type shell'
  gem.description    =  'TODO: Add description'
  gem.authors        =  ["Nate Collings"]
  gem.email          =  'nate@natecollings.com'
  gem.homepage       =  'https://github.com/naiyt/shell-sim'
  gem.license        =  'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(test|spec)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 2.1.5'
  gem.add_dependency 'highline'
  gem.add_dependency 'colorize'

  gem.add_development_dependency 'rspec', '>= 3.0.0'
  gem.add_development_dependency 'rspec-mocks', '>= 3.0.0'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-nav'
end

