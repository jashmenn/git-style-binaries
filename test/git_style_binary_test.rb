require File.dirname(__FILE__) + "/test_helper.rb"

class GitStyleBinariesTest < Test::Unit::TestCase
  context "parsing basenames" do
    should "accurately parse basenames" do
      assert_equal "wordpress", GitStyleBinary.basename("bin/wordpress")
      assert_equal "wordpress", GitStyleBinary.basename("bin/wordpress-post")
      assert_equal "wordpress", GitStyleBinary.basename("wordpress-post")
    end

    should "get the current command name" do
      assert_equal "wordpress",      GitStyleBinary.current_command_name("bin/wordpress", ["--help"])
      assert_equal "post", GitStyleBinary.current_command_name("bin/wordpress-post", ["--help"])
      assert_equal "post", GitStyleBinary.current_command_name("bin/wordpress post", ["--help"])
      assert_equal "post", GitStyleBinary.current_command_name("bin/wordpress post", [])
    end
  end
end
