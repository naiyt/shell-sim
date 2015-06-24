module Commands
  AVAILABLE_COMMANDS = [:exit, :ls, :cd, :help, :time]

  def self.exit
    abort
  end

  def self.help
    "Available commands:\n#{AVAILABLE_COMMANDS.join("\n")}"
  end

  def self.ls
  end

  def self.cd
  end

  def self.time
    Time.now()
  end
end