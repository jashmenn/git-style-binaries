require 'git-style-binary/parser'

module GitStyleBinary
class AutoRunner

  def self.run(argv=ARGV)
    r = new
    r.run
  end

  # returns exit code
  def run
    unless GitStyleBinary.run?
      GitStyleBinary.current_command.run
    end
  end

end
end
