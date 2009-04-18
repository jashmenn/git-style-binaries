require 'git-style-binary'
require 'git-style-binary/command'

module GitStyleBinary
  def self.primary(base_name=nil, &block)
  end

  class Primary < Command
    def initialize(base_name=nil)
      super
    end


# command = GitStyleBinary::primary("wordpress") do
#   version "#{$0} 0.0.1 (c) 2009 Nate Murray"
#   banner <<-EOS
# usage: #{$0} #{all_options.collect(:&to_s).join(" ")} COMMAND [ARGS]
#
# The wordpress subcommands commands are:
# {subcommands.pretty_print}
#
# See 'wordpress help COMMAND' for more information on a specific command.
# EOS
#   opt :verbose,  "verbose", :default => false
#   opt :dry,      "dry run", :default => false
#   opt :test_global, "a basic global string option", :type => String
# end
  end
end
