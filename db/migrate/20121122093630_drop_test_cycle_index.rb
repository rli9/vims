class DropTestCycleIndex < ActiveRecord::Migration
  def self.up
      remove_index("test_target_instance_test_results", :name => "index_by_test_case_and_test_cycle")
      remove_index("test_target_instance_test_results", :name => "index_by_test_case_and_test_cycle_and_created_by")
      remove_index("test_target_instance_test_results", :name => "index_test_case_id_and_test_cycle_id_and_created_by")
  end
  
  def self.down
    add_index("test_target_instance_test_results", [:test_cycle_id, :test_case_id], :name => "index_by_test_case_and_test_cycle")
    add_index("test_target_instance_test_results", [:test_case_id, :test_cycle_id, :created_by], :name => "index_test_case_id_and_test_cycle_id_and_created_by")
  end
end