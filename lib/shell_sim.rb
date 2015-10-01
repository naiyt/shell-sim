require 'shell_sim/config'
require 'shell_sim/output_helper'
require 'shell_sim/commands_helper'
require 'shell_sim/exceptions'
require 'shell_sim/filesystem'
require 'shell_sim/shell'
require 'shell_sim/user'
require 'shell_sim/scripting'

# TODO: figure out why I can't glob load these
require 'shell_sim/commands/cat'
require 'shell_sim/commands/cd'
require 'shell_sim/commands/echo'
require 'shell_sim/commands/exit'
require 'shell_sim/commands/filetype'
require 'shell_sim/commands/grep'
require 'shell_sim/commands/help'
require 'shell_sim/commands/history'
require 'shell_sim/commands/login'
require 'shell_sim/commands/ls'
require 'shell_sim/commands/man'
require 'shell_sim/commands/mkdir'
require 'shell_sim/commands/pwd'
require 'shell_sim/commands/rmdir'
require 'shell_sim/commands/task'
require 'shell_sim/commands/touch'

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

