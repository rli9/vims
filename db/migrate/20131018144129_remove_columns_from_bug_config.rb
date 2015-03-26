class RemoveColumnsFromBugConfig < ActiveRecord::Migration
  def change
    remove_column :bug_configs, :created_by
    remove_column :bug_configs, :updated_by
    remove_column :bug_configs, :remark
  end
end
