require "rspec/core/rake_task"
require "shell_sim"
require "yaml"
require "pry"

task :default => :spec
RSpec::Core::RakeTask.new

namespace :game do
  task :run do
    ShellSim.configure do |config|
      config.fs_data = YAML.load_file('spec/fs_fixture.yml')
      config.users_data = YAML.load_file('spec/users_fixture.yml')
    end

    shell = Shell.new('nate', 'password')
    shell.run
  end
end

