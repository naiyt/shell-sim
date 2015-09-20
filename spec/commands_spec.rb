require 'spec_helper'

describe 'initializing a filesystem' do
  before do
    ShellSim.configure do |config|
      config.fs_data = YAML.load_file('spec/fs_fixture.yml')
    end
  end

  it "works" do
    Filesystem::Filesystem.instance
  end
end

describe 'initializing the shell' do
  before do
    ShellSim.configure do |config|
      config.users_data = YAML.load_file('spec/users_fixture.yml')
    end
  end

  it 'works' do
    Shell.new('nate', 'password')
  end
end

