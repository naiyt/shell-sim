require 'shell-sim/config'
require 'shell-sim/commands_helper'
require 'shell-sim/exceptions'
require 'shell-sim/filesytem'
require 'shell-sim/output_helper'
require 'shell-sim/shell'
require 'shell-sim/user'

module ShellSim
  def self.configure
    yield config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end
end

