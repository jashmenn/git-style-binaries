require 'git-style-binary'
require 'git-style-binary/command'

module GitStyleBinary
  def self.primary(basename=nil, &block)
    basename ||= self.basename # ? 
    self.add_constraint(&block)
  end

  def self.populate_defaults
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
    end
  end

  class Primary < Command
    def initialize(base_name=nil)
      super
    end
  end
end
