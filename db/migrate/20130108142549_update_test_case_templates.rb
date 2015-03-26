class UpdateTestCaseTemplates < ActiveRecord::Migration
  def up
    rename_table("test_case_template_parameters", "test_case_template_params")
    add_column :test_case_template_params, :seq, :integer, :default => 0    
    TestCaseTemplate.all.each do |test_case_template|
      test_case_template_params = test_case_template.test_case_template_params.sort_by(&:id)
      
      test_case_template_params.each_index do |index|
        test_case_template_params[index].update(:seq => index)
      end      
    end
    rename_table("test_case_template_instances", "test_case_template_param_instances")
    rename_column("test_case_template_param_instances", "test_case_template_parameter_id", "test_case_template_param_id") 
            
    rename_table("test_case_test_case_template_instance_associations", "test_case_test_case_template_param_instance_associations")
    rename_column("test_case_test_case_template_param_instance_associations", "test_case_template_instance_id", "test_case_template_param_instance_id")
    rename_table("test_case_test_case_template_instance_joins", "test_case_test_case_template_param_instance_joins")
    rename_column("test_case_test_case_template_param_instance_joins", "test_case_template_instance_id_join", "test_case_template_param_instance_id_join")
  end
  
  def down
    
  end  
end