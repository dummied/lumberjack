require 'helper'

class TestLumberjack < Test::Unit::TestCase

  should "create an activity on standard AR actions" do
    user = TestUser.create(:name => "McTesty")
    assert_equal 1, TestUser.count
    response = TestModel.create(:name => "Testing", :test_user_id => user.id)
    assert_equal 1, Lumberjack::Activity.count
    assert_equal "McTesty created Testing", Lumberjack::Activity.first.to_s
  end
  
  should "handle an update as well" do
    TestModel.destroy_all
    TestUser.destroy_all
    Lumberjack::Activity.destroy_all
    user = TestUser.create(:name => "McTesty")
    response = TestModel.create!(:name => "Testing", :test_user_id => user.id)
    assert_equal "McTesty created Testing", Lumberjack::Activity.last.to_s
    response.update_attributes(:name => "Testing No. 2")
    assert_equal TestModel.count, 1
    assert_equal Lumberjack::Activity.count, 2
    assert_equal "McTesty updated Testing No. 2", Lumberjack::Activity.last.to_s
  end
  
  should "handle a destroy" do
    TestModel.destroy_all
    TestUser.destroy_all
    Lumberjack::Activity.destroy_all
    user = TestUser.create(:name => "McTesty")
    response = TestModel.create!(:name => "Testing", :test_user_id => user.id)
    assert_equal "McTesty created Testing", Lumberjack::Activity.last.to_s
    response.destroy
    assert_equal TestModel.count, 0
    assert_equal Lumberjack::Activity.count, 2
    assert_equal "McTesty destroyed Testing", Lumberjack::Activity.last.to_s
  end
  
  should "handle apporpriately-formatted random methods that return an object" do
    TestModel.destroy_all
    TestUser.destroy_all
    Lumberjack::Activity.destroy_all
    user = TestUser.create(:name => "McTesty")
    response = TestModel.create!(:name => "Testing", :test_user_id => user.id)
    assert_equal "McTesty created Testing", Lumberjack::Activity.last.to_s
    response.activate
    assert_equal "McTesty activated Testing", Lumberjack::Activity.last.to_s
  end
    
  should "handle apporpriately-formatted random methods that return a hash" do
    TestModel.destroy_all
    TestUser.destroy_all
    Lumberjack::Activity.destroy_all
    user = TestUser.create(:name => "McTesty")
    response = TestModel.create!(:name => "Testing", :test_user_id => user.id)
    assert_equal "McTesty created Testing", Lumberjack::Activity.last.to_s
    response.hashify
    assert_equal "McTesty bitch-slapped Testing", Lumberjack::Activity.last.to_s
  end
  
end
