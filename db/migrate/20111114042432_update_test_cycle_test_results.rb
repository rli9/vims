class UpdateTestCycleTestResults < ActiveRecord::Migration
  def up
    add_column :test_cycle_test_results, :value, :integer, :default => 0
    add_column :weighted_test_cycle_test_results, :value, :integer, :default => 0
    add_column :weighted_test_target_instance_test_results, :value, :integer, :default => 0
    
    remove_column :weighted_test_cycle_test_results, :test_target_pass
    remove_column :weighted_test_cycle_test_results, :test_target_fail
    remove_column :weighted_test_cycle_test_results, :test_target_block
    remove_column :weighted_test_cycle_test_results, :test_case_fail
    remove_column :weighted_test_cycle_test_results, :test_case_block
    remove_column :weighted_test_cycle_test_results, :created_by
    remove_column :weighted_test_cycle_test_results, :updated_by
    remove_column :weighted_test_cycle_test_results, :remark
    remove_column :weighted_test_cycle_test_results, :test_config_id
    
    remove_column :weighted_test_target_instance_test_results, :test_target_pass
    remove_column :weighted_test_target_instance_test_results, :test_target_fail
    remove_column :weighted_test_target_instance_test_results, :test_target_block
    remove_column :weighted_test_target_instance_test_results, :test_case_fail
    remove_column :weighted_test_target_instance_test_results, :test_case_block
    remove_column :weighted_test_target_instance_test_results, :created_by
    remove_column :weighted_test_target_instance_test_results, :updated_by
    remove_column :weighted_test_target_instance_test_results, :remark
    remove_column :weighted_test_target_instance_test_results, :test_config_id
    remove_column :weighted_test_target_instance_test_results, :test_cycle_id
                  
    TestCycleTestCaseTestResult.find_each do |test_result|
      test_result.value = test_result.test_target_pass | (test_result.test_target_fail << 1) | (test_result.test_target_block << 2) | (test_result.test_case_fail << 3) | (test_result.test_case_block << 4)
      test_result.save
    end
    
    remove_column :test_cycle_test_results, :test_target_pass
    remove_column :test_cycle_test_results, :test_target_fail
    remove_column :test_cycle_test_results, :test_target_block
    remove_column :test_cycle_test_results, :test_case_fail
    remove_column :test_cycle_test_results, :test_case_block
  end

  def down
  end
end
