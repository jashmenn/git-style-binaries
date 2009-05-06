module GitStyleBinary
module Helpers
  module NameResolver

    def basename(filename=zero)
      File.basename(filename).match(/(.*?)(\-|$)/).captures.first
    end

    # checks the bin directory for all files starting with +basename+ and
    # returns an array of strings specifying the subcommands
    def subcommand_names(filename=zero)
      subfiles = Dir[File.join(binary_directory, basename + "-*")]
      cmds = subfiles.collect{|file| File.basename(file).sub(/^#{basename}-/, '')}.sort
      cmds << "help" unless @no_help
      cmds
    end

    def binary_directory(filename=zero)
      File.dirname(filename)
    end

    def list_subcommands(filename=zero)
      subcommand_names(filename).join(", ")
    end

    def binary_filename_for(name)
      File.join(binary_directory, "#{basename}-#{name}") 
    end

    def current_command_name(filename=zero,argv=ARGV)
      current = File.basename(zero)
      first_arg = ARGV[0]
      return first_arg if valid_subcommand?(first_arg)
      return basename if basename == current
      current.sub(/^#{basename}-/, '')
    end

    # returns the command name with the prefix if needed
    def full_current_command_name(filename=zero,argv=ARGV)
      cur = current_command_name(filename, argv)
      subcmd = cur == basename(filename) ? false : true # is this a subcmd?
      "%s%s%s" % [basename(filename), subcmd ? "-" : "", subcmd ? current_command_name(filename, argv) : ""]
    end

    def valid_subcommand?(name)
      subcommand_names.include?(name)
    end

    def zero
      $0
    end

  end
end
end
