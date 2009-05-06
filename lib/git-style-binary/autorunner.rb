require 'git-style-binary/parser'

module GitStyleBinary
class AutoRunner

  def self.run(argv=ARGV)
    r = new
    r.run
  end

  # returns exit code
  def run
    # may not neede this blocking with @running
    unless GitStyleBinary.run? || @running
      puts "running"
      @running = true
      GitStyleBinary.current_command.run
      @running = false
    end
  end

end
end
