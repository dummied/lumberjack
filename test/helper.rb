require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lumberjack'
require 'create_test_models'

ActiveRecord::Base.establish_connection(
:adapter => "sqlite3",
:database => ":memory:",
:timeout => 5000

)

CreateTestModels.up

class Test::Unit::TestCase
end
