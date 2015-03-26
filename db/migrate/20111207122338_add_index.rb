class AddIndex < ActiveRecord::Migration
  def change
    add_index :test_cycle_role_associations, [:member_id, :test_cycle_id], :name => :index_by_member_and_test_cycle
    add_index :test_target_instances, :test_target_id, :name => :index_by_test_target
    add_index :member_project_associations, [:project_id, :member_id], :name => :index_by_project_and_member
    
    add_index :test_cycle_test_results, [:test_target_instance_id, :test_case_id], :name => :index_by_test_target_instance_and_test_case
    add_index :test_cycle_test_results, [:test_case_id, :test_cycle_id, :created_by], :name => :index_by_test_case_and_test_cycle_and_created_by
    
    add_index :weighted_test_target_instance_test_results, [:test_target_instance_id, :test_case_id], :name => :index_by_test_target_instance_and_test_case
    add_index :weighted_test_cycle_test_results, [:test_cycle_id, :test_case_id], :name => :index_by_test_cycle_and_test_case
    
    add_index :test_cases, [:test_target_id, :name], :name => :index_by_test_target_and_name#, :unique => true
  end
end
