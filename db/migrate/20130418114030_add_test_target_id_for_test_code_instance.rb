class AddTestTargetIdForTestCodeInstance < ActiveRecord::Migration
  def up
    add_column("test_code_instances", "test_target_id", :integer, :default => 25)
  end
  
  def down
    remove_column("test_code_instances", "test_target_id")
  end
  
end  