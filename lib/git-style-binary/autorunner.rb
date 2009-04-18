require 'git-style-binary/parser'

module GitStyleBinary
class AutoRunner
  attr_accessor :spec_block

  def self.run(argv=ARGV, &block)
    r = new(&block)
    # r.process_args(argv)
    r.run
  end

  def initialize(&block)
    @spec_block = block
  end

  # def process_args(args = ARGV, *a, &b)
  #   b ||= @spec_block
  #   @p = Parser.new(*a, &b)
  #   begin
  #     vals = @p.parse args
  #     args.clear
  #     @p.leftovers.each { |l| args << l }
  #     vals
  #   rescue Trollop::CommandlineError => e
  #     $stderr.puts "Error: #{e.message}."
  #     $stderr.puts "Try --help for help."
  #     exit(-1)
  #   rescue Trollop::HelpNeeded
  #     @p.educate
  #     exit
  #   rescue Trollop::VersionNeeded
  #     puts @p.version
  #     exit
  #   end
  # end

  # returns exit code
  def run
    populate_defaults
    load_parser_constraints

    puts "hi i ran!"
    p parser
    # result.run(@suite, @output_level).passed?
    0
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
