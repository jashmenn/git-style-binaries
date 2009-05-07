require 'git-style-binary'

module GitStyleBinary
  def self.command(&block)
    returning Command.new(:constraints => [block]) do |c|
      c.name ||= (GitStyleBinary.name_of_command_being_loaded || GitStyleBinary.current_command_name)
      GitStyleBinary.known_commands[c.name] = c

      if !GitStyleBinary.current_command || GitStyleBinary.current_command.is_primary?
        GitStyleBinary.current_command = c
      end
    end
  end

  def self.primary(&block)
    returning Primary.new(:constraints => [block]) do |c|
      c.name ||= (GitStyleBinary.name_of_command_being_loaded || GitStyleBinary.current_command_name)
      GitStyleBinary.known_commands[c.name] = c

      GitStyleBinary.primary_command = c unless GitStyleBinary.primary_command
      GitStyleBinary.current_command = c unless GitStyleBinary.current_command
    end
  end

  class Command
    class << self
      def defaults
        lambda do
          version "#{command.full_name} 0.0.1 (c) 2009 Nate Murray"
          banner <<-EOS
Usage: #{command.full_name} #{all_options_string} COMMAND [ARGS]

The wordpress subcommands are:
   \#{GitStyleBinary.pretty_known_subcommands.join("\n   ")}

See '#{command.full_name} help COMMAND' for more information on a specific command.
        EOS

          opt :verbose,  "verbose", :default => false
        end
      end
    end

    attr_reader :constraints
    attr_reader :opts
    attr_accessor :name

    def initialize(o={})
      o.each do |k,v|
        eval "@#{k.to_s}= v"
      end
    end

    def parser
      @parser ||= begin 
                    p = Parser.new
                    p.command = self
                    p
                  end
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
      # puts "loading constraints #{name} #{id}"
      @loaded_all_parser_constraints ||= begin
        load_parser_default_constraints
        load_parser_primary_constraints
        load_parser_local_constraints
        true
      end
    end

    def load_parser_default_constraints
      parser.consume_all([self.class.defaults])
    end

    def load_parser_primary_constraints
      parser.consume_all(GitStyleBinary.primary_command.constraints)
    end

    def load_parser_local_constraints 
      cur = GitStyleBinary.current_command # see, why isn't 'this' current_command?

      unless self.is_primary? && cur == self
        # TODO TODO - the key lies in this function. figure out when you hav emore engergy
        # soo UGLY. see #process_parser! unify with that method
        # parser.consume_all(constraints) rescue ArgumentError
        parser.consume_all(cur.constraints)
      end
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

    # TOOooootally ugly! why? bc load_parser_local_constraints doesn't work
    # when loading the indivdual commands because it depends on
    # #current_command. This really sucks and is UGLY. 
    # the todo is to put in 'load_all_parser_constraints' and this works
    def process_parser!
      # load_all_parser_constraints
      load_parser_default_constraints
      load_parser_primary_constraints
      # load_parser_local_constraints
      parser.consume_all(constraints)
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

    def argv
      parser.leftovers
    end

    def short_desc 
      parser.short_desc
    end

    # delegate other methods to the parser
    def method_missing(name, *args, &block)
      if parser.respond_to?(name)
        parser.send(name)
      else 
        super
      end
    end

    def full_name
      # ugly, should be is_primary?
      GitStyleBinary.primary_name == name ? GitStyleBinary.primary_name : GitStyleBinary.primary_name + "-" + name
    end

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
