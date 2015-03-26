class AddNameIndexForTestCaseTable < ActiveRecord::Migration
  def up
    add_index :test_cases, :name, :name => :index_by_name  
  end
  
  def down
    
  end
end