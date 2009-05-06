require 'trollop'
require 'lib/ext/core'
require 'git-style-binary/autorunner'
Dir[File.dirname(__FILE__) + "/git-style-binary/helpers/*.rb"].each {|f|  require f}

module GitStyleBinary
 
  class << self
    include Helpers::NameResolver

   # If set to false GitStyleBinary will not automatically run at exit.
    def run=(flag)
      @run = flag
    end

    # Automatically run at exit?
    def run?
      @run ||= false
    end

    def constraints
      @constraints ||= {}
    end

    def add_constraint(key, &block)
      self.constraints
      @constraints[key] ||= []
      @constraints[key] << block
    end

    def unshift_constraint(key, &block)
      self.constraints
      @constraints[key] ||= []
      @constraints[key].unshift(block)
    end

    def parser
      @p ||= Parser.new
    end

    def load_primary
      unless @loaded_primary
        @loaded_primary = true
        primary = File.join(binary_directory, basename) 
        load primary
      end
    end

    def populate_defaults
      self.unshift_constraint(:default) do
        version "#{bin_name} 0.0.1 (c) 2009 Nate Murray"
        banner <<-EOS
Usage: #{bin_name} #{all_options_string} COMMAND [ARGS]

The wordpress subcommands commands are:
   #{GitStyleBinary.subcommand_names.join("\n   ")}

See '#{bin_name} help COMMAND' for more information on a specific command.
      EOS

        opt :verbose,  "verbose", :default => false
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
