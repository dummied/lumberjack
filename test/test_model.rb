class TestModel < ActiveRecord::Base
  
  include Lumberjack
      
  belongs_to :test_user
  
  def to_param
    name
  end
  
  def activate
    return self
  end
  
  def hashify
    return {:source => test_user, :object => self, :verb => "bitch-slap"}
  end
  
  lumberjacks [:create, :update, :destroy, :activate, :hashify], :as => :test_user, :cache => true
  
  
  
end