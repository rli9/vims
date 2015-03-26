class ChangeTableName < ActiveRecord::Migration
  def up
    rename_table('test_case_test_case_template_instance_ids', 'test_case_test_case_template_instance_joins') 
  end
  
  def down
    rename_table('test_case_test_case_template_instance_joins', 'test_case_test_case_template_instance_ids') 
  end
end
