class RenameTableTestCycleTestCaseTestResults < ActiveRecord::Migration
  def self.up
    rename_table("test_cycle_test_results", "test_target_instance_test_results")
  end
  
  def self.down
    rename_table("test_target_instance_test_results", "test_cycle_test_results")
  end

end