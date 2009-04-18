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

    # def list_binaries_for(ty)
    #   available_binaries_for(ty).join(", ")
    # end
    # def available_binaries_for(ty)
    #   Dir["#{binary_directory}/#{ty}-*"].map {|a| File.basename(a.gsub(/#{ty}-/, '')) }.sort
    # end
    # def binary_directory
    #   "#{::File.dirname(__FILE__)}/../../bin"
    # end
  end

end

at_exit do
  unless $! || GitStyleBinary.run?
    exit GitStyleBinary::AutoRunner.run
  end
end
