module GitStyleBinary
  module Commands
    class Help
      # not loving this syntax, but works for now
      GitStyleBinary.command do
        short_desc "get help for a specific command"
        run do |command|
          def educate_about_command(name)
            puts "you want to know about #{name}?"
          end

          if command.argv.size > 0
            educate_about_command(command.argv.first)
          else
            educate
          end
        end
      end
    end
  end
end
