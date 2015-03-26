class DropTestCodeInstance < ActiveRecord::Migration
  def change
    drop_table 'test_code_instances'
    remove_column :test_results, :test_code_instance_id
    remove_column :weighted_test_results, :test_code_instance_id
  end
end
