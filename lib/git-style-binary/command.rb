require 'git-style-binary'

module GitStyleBinary
  def self.command(&block)
    load_primary 
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
