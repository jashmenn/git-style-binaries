require 'git-style-binary/command'

module GitStyleBinary
  def self.primary(&block)
    self.add_constraint(&block)
  end

  # class Primary < Command
  #   def initialize(base_name=nil)
  #     super
  #   end
  # end
end
