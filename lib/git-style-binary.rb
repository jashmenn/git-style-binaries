require 'trollop'
require 'lib/ext/core'
require 'git-style-binary/autorunner'
# require 'git-style-binary/command'
# require 'git-style-binary/primary'

module GitStyleBinary
 
  class << self
   # If set to false GitStyleBinary will not automatically run at exit.
    def run=(flag)
      @run = flag
    end

    # Automatically run at exit?
    def run?
      @run ||= false
    end

    def constraints
      @constraints ||= []
    end

    def add_constraint(&block)
      self.constraints
      @constraints << block
    end

    def unshift_constraint(&block)
      self.constraints
      @constraints.unshift(block)
    end

    def parser
      @p ||= Parser.new
    end

    def basename(filename=$0)
      File.basename(filename).match(/(.*?)(\-|$)/).captures.first
    end

    # checks the bin directory for all files starting with +basename+ and
    # returns an array of strings specifying the subcommands
    def subcommands(filename=$0)
      subfiles = Dir[File.join(binary_directory, basename + "-*")]
      cmds = subfiles.collect{|file| File.basename(file).sub(/^#{basename}-/, '')}.sort
      cmds << "help" unless @no_help
      cmds
    end

    def binary_directory(filename=$0)
      File.dirname(filename)
    end

    def list_subcommands(filename=$0)
      subcommands(filename).join(", ")
    end

    def load_primary
      unless @loaded_primary
        @loaded_primary = true
        primary = File.join(binary_directory, basename) 
        load primary
      end
    end

    def current_command_name
      current = File.basename($0)
      return basename if basename == current
      current.sub(/^#{basename}-/, '')
    end

    def populate_defaults
      self.unshift_constraint do
        version "#{bin_name} 0.0.1 (c) 2009 Nate Murray"

        # todo, collect the subcommands short description
        banner <<-EOS
Usage: #{bin_name} #{all_options_string} COMMAND [ARGS]

The wordpress subcommands commands are:
   #{GitStyleBinary.subcommands.join("\n   ")}

See '#{bin_name} help COMMAND' for more information on a specific command.
      EOS

        opt :verbose,  "verbose", :default => false

        # right here, put in the stops
      end
    end


  end

end

at_exit do
  unless $! || GitStyleBinary.run?
    command = GitStyleBinary::AutoRunner.run
    # command.exit_status # todo
    exit 0
  end
end
