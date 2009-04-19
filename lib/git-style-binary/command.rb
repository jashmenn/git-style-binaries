module GitStyleBinary
  def self.command(basename=nil, &block)
    basename ||= self.basename # ? 
    self.add_constraint(&block)
    command = GitStyleBinary::AutoRunner.run
  end

  class Command
    attr_accessor :global_opts
    attr_accessor :name
    attr_accessor :subcmd_opts
    attr_accessor :opts
    attr_accessor :argv
    attr_reader :basename

    def initialize(basename=nil)
    end

  end
end
