require 'git-style-binary/command'

module GitStyleBinary
  def self.primary(&block)
    # self.add_constraint(:primary, &block)
  end

  class Primary < Command
    def is_primary?
      true
    end
  end
end
