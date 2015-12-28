module ShellSim
  module Commands
    class Cat < Command
      def self.manual
        <<-EOS.strip_heredoc
          cat - send the contents of a file to stdout

          USAGE: cat [path to file]
        EOS
      end

      def run
        file_name = args[0]
        file = fs.get_file(file_name)
        file.data
      rescue Filesystem::FileDoesNotExistError
        { stderr: "cat: #{file_name} does not exist" }
      end
    end
  end
end
