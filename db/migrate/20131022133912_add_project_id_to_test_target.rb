class AddProjectIdToTestTarget < ActiveRecord::Migration
  def change
    add_column :test_targets, :project_id, :integer

    TestTargetProjectAssociation.all.each do |association|
      association.test_target.update(project_id: association.project_id)
    end

    drop_table 'test_target_project_associations'
  end
end
