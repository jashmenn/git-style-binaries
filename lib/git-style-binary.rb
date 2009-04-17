module GitStyleBinary
  # If set to false GitStyleBinary will not automatically run at exit.
  def self.run=(flag)
    @run = flag
  end

  # Automatically run at exit?
  def self.run?
    @run ||= false
  end
end

at_exit do
  unless $! || GitStyleBinary.run?
    exit GitStyleBinary::AutoRunner.run
  end
end
