class UpdateJoinTables < ActiveRecord::Migration
  def change
    rename_table :test_case_test_suite_associations, :test_cases_test_suites
    remove_columns :test_cases_test_suites, :id, :created_at, :updated_at

    add_index :test_cases_test_suites, [:test_case_id, :test_suite_id], unique: true
    add_index :test_cases_test_suites, [:test_suite_id, :test_case_id], unique: true

    drop_table :test_case_test_case_template_param_instance_associations

    rename_table :test_suite_test_suite_associations, :test_suites_test_suites
  end
end
