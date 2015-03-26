class DropTableWeightedTestCycleTestResults < ActiveRecord::Migration
  def self.up
    drop_table("weighted_test_cycle_test_results")
  end
  
  def self.down
    create_table("weighted_test_cycle_test_results") do |t|
      t.integer "test_case_id", :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer "test_target_instance_id", :null => false
      t.integer "test_cycle_id", :default => nil
      t.integer "value", :default => 0
    end 
  end
end