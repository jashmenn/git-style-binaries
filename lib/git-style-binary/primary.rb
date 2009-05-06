require 'git-style-binary/command'

module GitStyleBinary
  def self.primary(&block)
    self.add_constraint(:primary, &block)
  end
end
