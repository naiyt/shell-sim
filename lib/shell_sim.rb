require 'shell_sim/config'
require 'shell_sim/output_helper'
require 'shell_sim/commands_helper'
require 'shell_sim/exceptions'
require 'shell_sim/filesystem'
require 'shell_sim/shell'
require 'shell_sim/user'
require 'shell_sim/scripting'

Gem.find_files('shell_sim/**/commands/*.rb').each { |f| require f }

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

# http://stackoverflow.com/a/5638187/1026980
class String
  def strip_heredoc
    gsub /^#{self[/\A[ \t]*/]}/, ''
  end
end
