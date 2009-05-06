require 'git-style-binary'

module GitStyleBinary
  def self.command(&block)
    returning Command.new(:constraints => [block]) do |c|
      if !GitStyleBinary.current_command || GitStyleBinary.current_command.is_primary?
        GitStyleBinary.current_command = c
      end
    end
  end

  def self.primary(&block)
    returning Primary.new(:constraints => [block]) do |c|
      GitStyleBinary.primary_command = c unless GitStyleBinary.primary_command
      GitStyleBinary.current_command = c unless GitStyleBinary.current_command
    end
  end

  class Command
    class << self
      def defaults
        lambda do
          version "#{bin_name} 0.0.1 (c) 2009 Nate Murray"
          banner <<-EOS
Usage: #{bin_name} #{all_options_string} COMMAND [ARGS]

The wordpress subcommands commands are:
   #{GitStyleBinary.subcommand_names.join("\n   ")}

See '#{bin_name} help COMMAND' for more information on a specific command.
        EOS

          opt :verbose,  "verbose", :default => false
        end
      end
    end

    attr_reader :constraints
    attr_reader :opts

    def initialize(o={})
      o.each do |k,v|
        eval "@#{k.to_s}= v"
      end
    end

    def parser
      @parser ||= Parser.new
    end

    def constraints
      @constraints ||= []
    end

    def run
      GitStyleBinary.load_primary    unless is_primary?
      GitStyleBinary.load_subcommand if is_primary? && running_subcommand?
      load_all_parser_constraints
      @opts = process_args_with_subcmd
      call_parser_run_block
      self
    end

    def running_subcommand?
      GitStyleBinary.valid_subcommand?(GitStyleBinary.current_command_name)
    end

    def load_all_parser_constraints
      load_parser_default_constraints
      load_parser_primary_constraints
      load_parser_local_constraints
    end

    def load_parser_default_constraints
      parser.consume_all([self.class.defaults])
    end

    def load_parser_primary_constraints
      parser.consume_all(GitStyleBinary.primary_command.constraints)
    end

    def load_parser_local_constraints 
      cur = GitStyleBinary.current_command
      parser.consume_all(cur.constraints) unless self.is_primary? && cur == self
    end

    def call_parser_run_block
      runs = GitStyleBinary.current_command.parser.runs
      parser.runs.last.call(self) # ... not too happy with this
    end

    def process_args_with_subcmd(args = ARGV, *a, &b)
      cmd = GitStyleBinary.current_command_name
      vals = process_args(args, *a, &b)
      parser.leftovers.shift if parser.leftovers[0] == cmd
      vals
    end

    def process_args(args = ARGV, *a, &b)
      p = parser
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

    def is_primary?
      false
    end

    def name
      GitStyleBinary.current_command_name
    end

    def argv
      parser.leftovers
    end

    # def die(*args)
    #   parser.die(*args)
    # end

  end

  class Primary < Command
    def is_primary?
      true
    end
    def primary
      self
    end
  end

end
