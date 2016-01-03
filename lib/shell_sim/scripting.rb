module ShellSim
  module Scripts
    def self.shell
      @shell ||= Shell.new('nate', 'password') # TODO - actually setup a game user
    end

    class Script
      include Commands::OutputHelper
      attr_accessor :shell, :name

      def initialize(&block)
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

      def output(text, type=:standard)
        # sends to the Commands::OutputHelper methods
        unless text.nil?
          surrounding_text = self.send(type, "=" * text.size)
          output_text = self.send(type, text) unless text.nil?
          if type == :info
            output_text = "#{surrounding_text}\n#{output_text}\n#{surrounding_text}"
          end
          puts output_text
        end
      end

      def handle_command(result, cmds)
        @latest_cmds = cmds
        @latest_res = result

        @expectations.shift if @expectations[0].call
      end

      def expect_cmd(cmd, txt=nil)
        @expectations << lambda { is_latest_cmd?(cmd) }
      end

      def expect_cmd_with_args(cmd, args, txt=nil)
        @expectations << lambda { is_latest_cmd?(cmd) && is_latest_args?(Array(args)) }
      end

      def expect_pwd_to_be(dir, txt=nil)
        @expectations << lambda { @fs.pwd.path_to == dir }
      end

      def expect_file_to_exist(filepath, txt=nil)
        @expectations << lambda { @fs.file_exists?(filepath) }
      end

      def expect_dir_to_exist(dir_name, txt=nil)
        raise
      end

      def expect_current_user_to_be(user_name, txt=nil)
        @expectations << lambda { @shell.user.name.to_sym == user_name }
      end

      def greeting
        output("Welcome to #{@name}", :info)
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

