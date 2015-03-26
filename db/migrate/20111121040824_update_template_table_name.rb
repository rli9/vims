class UpdateTemplateTableName < ActiveRecord::Migration
  def up
    rename_column("test_case_templates", "test_case_template_target_id", "test_case_template_id")
	  rename_column("test_case_test_case_template_instance_ids", "test_case_template_instance_ids", "test_case_template_param_instance_id_join")
    rename_column("test_case_template_instances", "test_case_template_id", "test_case_template_parameter_id")   
    rename_column("member_template_sequences", "test_case_template_target_id", "test_case_template_id")       
    rename_table("test_case_templates", "test_case_template_parameters")
    rename_table("test_case_template_targets", "test_case_templates")
  end

  def down
    rename_table("test_case_template_parameters", "test_case_templates")
    rename_table("test_case_templates", "test_case_template_targets")
    rename_column("test_case_templates", "test_case_template_id", "test_case_template_target_id")
	  rename_column("test_case_test_case_template_instance_ids", "test_case_template_param_instance_id_join", "test_case_template_instance_ids")
    rename_column("test_case_template_instances", "test_case_template_parameter_id", "test_case_template_id")
    rename_column("member_template_sequences", "test_case_template_id", "test_case_template_target_id")      
  end
end
