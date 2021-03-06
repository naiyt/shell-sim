module ShellSim
  module Commands
    class NotImplemented < StandardError
    end
  end

  module Filesystem
    class AlreadyExistsError < StandardError
    end

    class FileDoesNotExistError < StandardError
    end

    class DirectoryNotEmptyError < StandardError
    end

    class FileAlreadyExists < StandardError
    end

    class PathDoesNotExist < StandardError
    end

    class FileNotDir < StandardError
    end
  end
end
