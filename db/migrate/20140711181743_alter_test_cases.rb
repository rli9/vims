class AlterTestCases < ActiveRecord::Migration
  def change
    remove_columns :test_cases, :created_by
  end
end
