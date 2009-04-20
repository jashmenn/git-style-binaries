require File.dirname(__FILE__) + "/test_helper.rb"

class GitStyleBinariesTest < Test::Unit::TestCase
  context "parsing basenames" do
    should "accurately parse basenames" do
      assert_equal "wordpress", GitStyleBinary.basename("bin/wordpress")
      assert_equal "wordpress", GitStyleBinary.basename("bin/wordpress-post")
      assert_equal "wordpress", GitStyleBinary.basename("wordpress-post")
    end
  end
end
