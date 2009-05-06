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

          def load_all_commands
            GitStyleBinary.subcommand_names.each do |name|
              cmd_file = GitStyleBinary.binary_filename_for(name)
              GitStyleBinary.load_command_file(name, cmd_file)
            end
          end

          if command.argv.size > 0
            educate_about_command(command.argv.first)
          else
            load_all_commands
            p [:loaded]
            p GitStyleBinary.known_commands.keys
            educate
          end

        end
      end
    end
  end
end
