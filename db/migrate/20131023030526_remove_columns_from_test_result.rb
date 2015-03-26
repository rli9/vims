class RemoveColumnsFromTestResult < ActiveRecord::Migration
  def change
    remove_column :test_results, :remark
    remove_column :test_results, :test_config_id
  end
end
