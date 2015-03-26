class SecondAddIndex < ActiveRecord::Migration
  def change
    add_index :test_cycle_test_results, [:test_case_id, :test_cycle_id], :name => :index_by_test_case_and_test_cycle
    add_index :test_case_test_case_template_instance_joins, [:test_case_template_param_instance_id_join], :name => :index_by_test_case_template_param_instance_id_join
   
  end
end