module GitStyleBinary
  def self.command(*args)
  end

  class Command
    attr_reader :base_name
    def initialize(base_name=nil)
      @base_name = base_name ? base_name : $0.match(/(.*?)\-/).captures.first
      puts base_name
    end
  end
end
