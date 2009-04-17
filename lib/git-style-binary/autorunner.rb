module GitStyleBinary
  class AutoRunner

      def self.run(force_standalone=false, default_dir=nil, argv=ARGV, &block)
        # r = new(force_standalone || standalone?, &block)
        # r.base = default_dir
        # r.process_args(argv)
        # r.run
      end

      def initialize(standalone)
        # Unit.run = true
        # @standalone = standalone
        # @runner = RUNNERS[:console]
        # @collector = COLLECTORS[(standalone ? :dir : :objectspace)]
        # @filters = []
        # @to_run = []
        # @output_level = UI::NORMAL
        # @workdir = nil
        # yield(self) if(block_given?)
      end

      def process_args(args = ARGV)
        # begin
        #   options.order!(args) {|arg| @to_run << arg}
        # rescue OptionParser::ParseError => e
        #   puts e
        #   puts options
        #   $! = nil
        #   abort
        # else
        #   @filters << proc{false} unless(@filters.empty?)
        # end
        # not @to_run.empty?
      end

      def options
        @options ||= OptionParser.new do |o|
          # ...
        end
      end

      def run
        # @suite = @collector[self]
        # result = @runner[self] or return false
        # Dir.chdir(@workdir) if @workdir
        # result.run(@suite, @output_level).passed?
      end
 
  end
end
