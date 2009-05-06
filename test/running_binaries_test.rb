require File.dirname(__FILE__) + "/test_helper.rb"
require 'open3'

module RunsBinaryFixtures
  # run the specified cmd returning the string values of [stdout,stderr]
  def bin(cmd)
    stdin, stdout, stderr = Open3.popen3("#{fixtures_dir}/#{cmd}")
    [stdout.read, stderr.read]
  end
end

class RunningBinariesTest < Test::Unit::TestCase
  include RunsBinaryFixtures

  context "when running primary" do
    context "and getting help" do
      setup { @stdout, @stderr = bin("wordpress -h") }

      should "have a local (not default) version string" do
        output_matches /wordpress 0\.0\.1 \(c\) 2009 Nate Murray - local/
      end

      should "get a list of subcommands" do
        output_matches /The wordpress subcommands commands are:\n\s*post\s*help/m
      end

      should "have a usage" do
        output_matches /Usage: wordpress \[/
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
  end

  context "when running the subcommand" do
    # should be the same for both formats
    ["wordpress-post", "wordpress post"].each do |bin_format|
      context "#{bin_format}" do

        context "and getting help" do
          setup { @stdout, @stderr = bin("#{bin_format} -h") }

          should "have a the primaries version string, except correct binary name" do
             output_matches /wordpress-post 0\.0\.1 \(c\) 2009 Nate Murray - local/
          end

          should "have a usage" do
            output_matches "Usage:"
          end

          should "have a description" do
            output_matches /Posts content to a wordpress blog/
          end

          should "have options" do
            output_matches /Options:/
            output_matches /--blog, -b <s>:   short name of the blog to use \(default: default\)/
            output_matches /--title, -i <s>:   title for the post/
          end

        end

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

      end # end bin_format
    end # end #each
  end
end
