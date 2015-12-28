# Shell Emulator

This is a basic emulation of a *nix shell and filesystem. This was mainly done as a fun excercise/experiment, and as a possible way to create a "hacking game" of sorts (think Uplink or HackNet). As such, it also includes [a barebones scripting DSL](https://github.com/naiyt/shell-sim/blob/master/lib/shell_sim/scripting.rb). This DSL can do things like expect commands to be run with certain arguments, or for specific files or directories to exist.

Unlike a real shell, there is no actual forking of processes. Every command is just a shell builtin.

The filesystem is composed of essentially fake directory and file objects, maintained by a `FileSystem` singelton.

The purpose of this is *not* to make any sort of actual viable shell. It's just a fun experiment to play around with Ruby and learn some interesting shell concepts.

## How to mess around with this

You can clone this repo, do a `bundle install` and then `bundle exec ruby test_run.rb`.

## Configuration

This project is also packaged as a gem, which means you can require it somewhere, and then use the included scripting DSL to create some sort of simple game or tutorial.

Add to your Gemfile:

`gem 'shell_sim', git: 'git@github.com:naiyt/shell-sim.git'`

Configure as follows:

```ruby
require 'shell_sim'

ShellSim.configure do |config|
  config.fs_data    =  { 'root' => ['tmp', {'home' => ['nate']}]}# The structure of your filesystem
  config.users_data =  { 'root' => {'password' => 'pass', 'super_user' => true}, 'nate' => {'password': 'pass', 'super_user' => false}}
end

shell = ShellSim::Shell.new('root', 'password')
shell.run
```

You can also structure your `fs_data` and `users_data` with YAML, as shown [here](https://github.com/naiyt/shell-sim/blob/master/test_run.rb).

## Things this can do

- All of the commands [here](https://github.com/naiyt/shell-sim/tree/master/lib/shell_sim/commands) have been implemented and run in some way. [grep](https://github.com/naiyt/shell-sim/blob/master/lib/shell_sim/commands/grep.rb) is probably the most interesting one at the moment, doesn't work with anything but stdin yet.
- Pipes work (more or less), as does output redirection with both `>` and `>>`. Try something like this:

```shell
[root@hacksh /]: echo "Hacking for fun and profit!" > test.txt
[root@hacksh /]: ls
tmp   usr   etc   home   test.txt
[root@hacksh /]: echo "Unix/Linux/OSX/Solaris" > test2.txt
[root@hacksh /]: cat test.txt
Hacking for fun and profit!
[root@hacksh /]: cat test.txt | grep Hacking
Hacking for fun and profit!
[root@hacksh /]: cat test2.txt | grep Hacking
[root@hacksh /]:
```

- The concept of stderr and stdout exists.
- The concept of users with passwords exists.
- You can make and delete files and directories.
- A command can have a `man` page by implementing the `manual` method.

## Things this can't do

- Any changes to the filesystem are not currently persisted when closing the program.
- No concept of user permissions exists.
- No text editors of any sort. (To write to a file, use `echo` and output redirection.)
- A billion other things.

## Using the scripting DSL

[See here for examples](https://github.com/naiyt/hacking_game/tree/master/levels).

## Implementing a command

New commands must be placed inside of [`lib/shell_sim/commands`](https://github.com/naiyt/shell-sim/tree/master/lib/shell_sim/commands). They must be created as a class that inherits from `Command` with a `run` method.

From there, the command has access to:

- `args`: an array of the command line arguments
- `get_input`: retrieves `stdin` (whether from a piped command or typed by the user)

Return `nil` or `false` if you wish the command to complete silently. Otherwise, just return a string to go to `stdout`.

If you want to write to `stderr`, your `run` method should return a hash in the following format: `{ stderr: 'Erro message' }`.

Here's an example of a pointless command called `cool`. If you pass this command a list of names it will state their coolness factor. If you pass it no names, it will send an error to stderr.

```ruby
module ShellSim
  module Commands
    class Cool < Command
      def self.manual
        <<-EOS.strip_heredoc
          cool - determine the coolness of people.

          Usage: cool [list of names]
        EOS
      end

      def run
        if args.length == 0
          { stderr: "Nobody is cool..." }
        else
          args.map do |person|
            "#{person} is #{coolness_levels.sample} cool!"
          end.join("\n")
        end
      end

      private

      def coolness_levels
        ["pretty", "very", "extremely", "not very", "overwhelmingly", "freezing"]
      end
    end
  end
end
```

```shell
[root@hacksh /]: cool Tanya Nate Kira Christa Sean
Tanya is overwhelmingly cool!
Nate is very cool!
Kira is pretty cool!
Christa is overwhelmingly cool!
Sean is pretty cool!
```

## Future plans / TODOs

- Plenty of other fun commands could be implemented. For example:
  - rm
  - whoami
  - mail
  - text editing of some sort
  - xargs
  - ps
  - ssh
  - chmod
  - chown
  - find
  - sudo
  - ???
- The ability to cd directly into a subdirectory (can only navigate through single levels currently)
- Filesystem serialization (to persist between running the program)
- User permissions
- Support for `;` and/or `&&`
- Add better specs. (Somewhat difficult)
- More scripting options
