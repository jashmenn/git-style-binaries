module GitStyleBinary
  # If set to false GitStyleBinary will not automatically run at exit.
  def self.run=(flag)
    @run = flag
  end

  # Automatically run at exit?
  def self.run?
    @run ||= false
  end

  class << self
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
