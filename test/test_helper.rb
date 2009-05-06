require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
Dir[File.join(File.dirname(__FILE__), "shoulda_macros", "*.rb")].each {|f| require f}

require 'git-style-binary'
GitStyleBinary.run = true

class Test::Unit::TestCase
  def fixtures_dir
    File.join(File.dirname(__FILE__), "fixtures")
  end
end
