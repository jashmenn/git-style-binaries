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
      GitStyleBinary.run = true # maybe mv to bottom
      populate_defaults
      load_parser_constraints
      args = process_args_with_subcmd
      c = Command.new(:opts => args, :argv => ARGV, :name => GitStyleBinary.current_command_name)
      parser.runs.last.call(c) # ... not too happy with this
      c
    else
      parser.consume(&GitStyleBinary.constraints.last)
    end
  end

  def process_args_with_subcmd(args = ARGV, *a, &b)
    cmd = GitStyleBinary.current_command_name
    vals = process_args(args, *a, &b)
    if parser.leftovers.size > 0 && parser.leftovers.first == cmd
      parser.leftovers.shift 
      load GitStyleBinary.binary_filename_for(cmd) # uh nope. doesn't work
      vals = process_args parser.leftovers
    end
    vals
  end

  def process_args(args = ARGV, *a, &b)
    p = parser
    p.stop_on GitStyleBinary.current_command_name
    begin
      vals = p.parse args
      args.clear
      p.leftovers.each { |l| args << l }
      vals # ugly todo
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
