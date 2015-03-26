class RemoveColumns < ActiveRecord::Migration
  def change
    remove_column :test_target_instances, :remark
    remove_column :test_targets, :remark

    remove_column :test_case_templates, :remark

    remove_columns :test_case_test_case_template_param_instance_associations, :created_at, :updated_at

    remove_columns :test_case_template_params, :remark, :created_at, :updated_at

    remove_columns :test_case_template_param_instances, :created_at, :updated_at

    remove_columns :test_cases, :remark, :test_case_status_type_id, :description, :created_at, :lowercase_name, :updated_at, :command, :test_type_id, :first_test_case_id, :test_execution_time, :created_by, :version, :next_test_case_id

    remove_column :test_suites, :remark
    remove_column :projects, :remark
    remove_column :pictures, :remark
    remove_column :members, :remark
    remove_column :change_lists, :remark

    drop_table :test_case_status_types
  end
end
