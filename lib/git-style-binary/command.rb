require 'git-style-binary'
require 'git-style-binary/primary'
require 'git-style-binary/command'

module GitStyleBinary
  def self.command(basename=nil, &block)
    basename ||= GitStyleBinary.basename # ? 
    self.add_constraint(&block)
    command = GitStyleBinary::AutoRunner.run
  end

  class Command
    attr_accessor :name
    attr_accessor :opts
    attr_accessor :argv

    attr_reader :basename

    def initialize(opts={})
      opts.each do |k,v|
        eval "@#{k.to_s}= v"
      end
    end

  end
end
