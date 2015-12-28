# Run me with: bundle exec ruby test_run.rb

require 'shell_sim'
require 'yaml'

ShellSim.configure do |config|
  config.fs_data    = YAML.load_file('spec/fs_fixture.yml')
  config.users_data = YAML.load_file('spec/users_fixture.yml')
end

shell = ShellSim::Shell.new('root', 'password')
shell.run
