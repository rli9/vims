class UpdateJoinTables2 < ActiveRecord::Migration
  def change
    rename_table :test_cases_test_suites, :test_cases_suites
  end
end
