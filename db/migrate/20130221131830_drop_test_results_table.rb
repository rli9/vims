class DropTestResultsTable < ActiveRecord::Migration
  def up
    drop_table("test_results")
    drop_table("test_result_suites")
    drop_table("test_result_test_result_suite_associations")
  end
  
  def down
    
  end
end