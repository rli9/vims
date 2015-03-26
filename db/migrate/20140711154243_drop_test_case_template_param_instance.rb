class DropTestCaseTemplateParamInstance < ActiveRecord::Migration
  def change
    drop_table :test_case_template_param_instances
  end
end
