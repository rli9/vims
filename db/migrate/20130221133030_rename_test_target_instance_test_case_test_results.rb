class RenameTestTargetInstanceTestCaseTestResults < ActiveRecord::Migration
  
  def up
    rename_table("test_target_instance_test_case_test_results", "test_results")
    rename_table("weighted_test_target_instance_test_case_test_results", "weighted_test_results")
  end
  
  def down
    rename_table("test_results", "test_target_instance_test_case_test_results")
    rename_table("weighted_test_results", "weighted_test_target_instance_test_case_test_results")
  end
  
end