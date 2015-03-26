class DropTestCycleIdColumn < ActiveRecord::Migration
  def self.up
    remove_column("test_target_instance_test_results", [:test_cycle_id])
  end
  
  def self.down
    add_column("test_target_instance_test_results", "test_cycle_id", :integer, :default => nil)
  end
end