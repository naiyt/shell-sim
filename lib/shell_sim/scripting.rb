module ShellSim
  module Scripts
    def self.shell
      @shell ||= Shell.new('nate', 'password') # TODO - actually setup a game user
    end

    class Script
      attr_accessor :shell, :name

      def initialize(terminal, &block)
        @terminal = terminal
        @shell = Scripts.shell
        @fs = Filesystem::Filesystem.instance
        @expectations = []
        instance_eval(&block)
      end

      # DSL methods

      def level_name(n)
        @name = n
      end

      def load_users(users_data)
        Users.resetup_users(users_data)
      end

      def login_as(user_name)
        @shell.user = Users.users[user_name] # bypasses authentication
      end

      def buffer_output(text, type=:standard)
        @terminal.add_to_buffer(text) unless text.nil?
      end

      def output(txt)
        if @expectations.length == 0
          buffer_output(txt)
        else
          @expectations << { txt: txt, only_txt: true }
        end
      end

      def handle_command(result, cmds)
        @latest_cmds = cmds
        @latest_res = result

        expectation = @expectations[0]

        buffer_output("Current task: #{expectation[:txt]}") if cmds && cmds.first[:cmd] == :task

        if expectation[:only_txt]
          @expectations.shift
          buffer_output expectation[:text]
        elsif expectation[:cmd].call
          @expectations.shift
          buffer_output @expectations[0][:txt] if @expectations.size > 0
        end
      end

      def add_expectation(expectation, txt)
        buffer_output txt if @expectations.length == 0
        @expectations << { cmd: expectation, txt: txt }
      end

      def expect_cmd(cmd, txt=nil)
        expectation = lambda { is_latest_cmd?(cmd) }
        add_expectation(expectation, txt)
      end

      def expect_cmd_with_args(cmd, args, txt=nil)
        expectation = lambda { is_latest_cmd?(cmd) && is_latest_args?(Array(args)) }
        add_expectation(expectation, txt)
      end

      def expect_pwd_to_be(dir, txt=nil)
        expectation = lambda { @fs.pwd.path_to == dir }
        add_expectation(expectation, txt)
      end

      def expect_file_to_exist(filepath, txt=nil)
        expectation = lambda { @fs.file_exists?(filepath) }
        add_expectation(expectation, txt)
      end

      def expect_dir_to_exist(dir_name, txt=nil)
        raise
      end

      def expect_current_user_to_be(user_name, txt=nil)
        expectation = lambda { @shell.user.name.to_sym == user_name }
        add_expectation(expectation, txt)
      end

      def greeting
        buffer_output("Welcome to #{@name}", :info)
      end

      def available_commands(cmds)
        cmds << :task
        cmds << :exit
        Commands.available_commands = cmds
      end

      private

      def is_latest_cmd?(cmd)
        unless @latest_cmds.nil?
          @latest_cmds.map { |c| c[:cmd] }.include? cmd.to_sym
        end
      end

      def is_latest_args?(args)
        unless @latest_cmds.nil?
          args == @latest_cmds.map { |c| c[:args].map { |a| a.to_sym} }.flatten
        end
      end
    end
  end
end

