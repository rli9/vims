class RemoveTimeStampFromWeightedTestResult < ActiveRecord::Migration
  def change
    remove_column :weighted_test_results, :created_at
    remove_column :weighted_test_results, :updated_at
  end
end
