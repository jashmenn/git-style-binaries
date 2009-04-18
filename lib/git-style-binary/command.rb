module GitStyleBinary
  def self.command(*args)
  end

  class Command
    attr_reader :basename
    def initialize(basename=nil)
      puts basename
    end
  end
end
