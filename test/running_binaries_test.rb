require File.dirname(__FILE__) + "/test_helper.rb"

class RunningBinariesTest < Test::Unit::TestCase
  include RunsBinaryFixtures

  context "when running primary" do
    ["wordpress -h", "wordpress help"].each do |format|
      context "and getting help as a '#{format}'" do
        setup { @stdout, @stderr = bin(format) }

        should "have a local (not default) version string" do
          # puts @stdout, @stderr
          output_matches /wordpress(\-help)? 0\.0\.1 \(c\) 2009 Nate Murray - local/
        end

        should "get a list of subcommands" do
          output_matches /The wordpress subcommands are:\n\s*help\s*get help for a specific command\s*post\s*create a blog post/m
        end

        should "have subcommand short descriptions" do
          output_matches /post\s*create a blog post/
          output_matches /help\s*get help for a specific command/
        end

        should "have a usage" do
          output_matches /Usage: wordpress(\-help)? \[/
        end

        should "be able to ask for help about help"
      end
    end

    context "and getting help as subcommand" do
      # ["wordpress -h", "wordpress help"].each do |format|
      ["wordpress help"].each do |format|
        context "'#{format}'" do
          should "get help on subcommand post"
        end
      end
    end

    context "with no options" do
      setup { @stdout, @stderr = bin("wordpress") }

      should "output the options" do
        output_matches /Primary Options:/
      end

      should "have the test_primary option" do
        output_matches /test_primary=>nil/
      end
    end
    should "be able to require 'primary' and run just fine"
  end

  context "when running the subcommand" do
    # should be the same for both formats
    ["wordpress-post", "wordpress post"].each do |bin_format|
      context "#{bin_format}" do


        context "with no options" do
          setup { @stdout, @stderr = bin("#{bin_format}") }
          should "fail because title is required" do
            output_matches /Error: option 'title' must be specified.\s*Try --help for help/m
          end
        end

        context "with options" do
          setup { @stdout, @stderr = bin("#{bin_format} --title='glendale'") }
          should "be running the subcommand's run block" do
            output_matches /Subcommand name/
          end
          should "have some default options" do
            output_matches /version=>false/
            output_matches /help=>false/
          end
          should "have some primary options" do
            output_matches /test_primary=>nil/
          end
          should "have some local options" do
            output_matches /title=>"glendale"/
            output_matches /type=>"html"/
          end
        end

        should "die on command.die statements"

      end # end bin_format
    end # end #each
  end

  ["wordpress help post", "wordpress post -h", "wordpress -h post"].each do |format| 
    context "when calling #{format}" do
      
      setup { @stdout, @stderr = bin(format) }
      should "have a description" do
        output_matches /Posts content to a wordpress blog/
      end

      should "have the proper usage line" do
        output_matches "Usage:"
        output_matches /Usage: wordpress\-post/
        output_matches /\[--title\]/
      end

      should "have option flags" do
        output_matches /\-\-title <s>/
      end

      should "have primary option flags" do
        output_matches /\-\-test-primary <s>/
      end

      should "have default option flags" do
        output_matches /\-\-version, \-e:/
      end

      should "have a the primaries version string, except correct binary name" do
         output_matches /wordpress-post 0\.0\.1 \(c\) 2009 Nate Murray - local/
      end

      should "have options" do
        output_matches /Options:/
        output_matches /--blog, -b <s>:   short name of the blog to use \(default: default\)/
        output_matches /--title, -i <s>:   title for the post/
      end

    end
  end

end
