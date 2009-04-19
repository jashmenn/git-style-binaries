require 'trollop'
require 'lib/ext/core'
require 'git-style-binary/autorunner'

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
      @constraints ||= []
      @constraints << block
    end

    def parser
      @p ||= Parser.new
    end

    def basename(filename=$0)
      @basename ||= File.basename(filename).match(/(.*)\-?/).captures.first
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
  end

end

at_exit do
  unless $! || GitStyleBinary.run?
    exit GitStyleBinary::AutoRunner.run
  end
end
