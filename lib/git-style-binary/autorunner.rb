require 'git-style-binary/parser'

module GitStyleBinary
class AutoRunner

  def self.run(argv=ARGV)
    r = new
    r.run
  end

  # returns exit code
  def run
    populate_defaults
    load_parser_constraints
    process_args
    0
  end

  def process_args(args = ARGV, *a, &b)
    p = parser
    begin
      vals = p.parse args
      args.clear
      p.leftovers.each { |l| args << l }
      vals
    rescue Trollop::CommandlineError => e
      $stderr.puts "Error: #{e.message}."
      $stderr.puts "Try --help for help."
      exit(-1)
    rescue Trollop::HelpNeeded
      p.educate
      exit
    rescue Trollop::VersionNeeded
      puts p.version
      exit
    end
  end

  def parser
    GitStyleBinary.parser
  end

  def populate_defaults
    GitStyleBinary.populate_defaults
  end

  def load_parser_constraints
    GitStyleBinary.constraints.each do |c_block|
      parser.consume(&c_block)
    end
  end

end
end
