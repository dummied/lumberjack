class TestUser < ActiveRecord::Base
    
  has_many :test_models
  has_many :activities
  
  def to_param
    name
  end
  
end