require 'spec_helper'

describe 'initializing a filesystem' do
  let(:default_fs) { YAML.load_file('spec/fs_fixture.yml') }

  it "works" do
    Filesystem::Filesystem.instance.reinit(default_fs)
  end
end

