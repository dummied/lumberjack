class CreateTestModels < ActiveRecord::Migration
  def self.up
    create_table :test_models, :force => true do |t|
      t.string :name
      t.integer :test_user_id
      t.timestamps
    end
    
    create_table :test_users, :force => true do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :activities, :force => true do |t|
      t.integer :source_id
      t.string  :source_type
      t.string  :verb
      t.integer :object_id
      t.string :object_type
      t.string :cached_to_s
      t.timestamps
    end
    
  end
  
  
end