class UpdateMemberProjectJoinTable < ActiveRecord::Migration
  def change
    rename_table :member_project_associations, :members_projects

    remove_column :members_projects, :id
    remove_column :members_projects, :created_at
    remove_column :members_projects, :updated_at
    remove_column :members_projects, :remark
  end
end
