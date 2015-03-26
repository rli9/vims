class RemoveColumnsFromBugTrack < ActiveRecord::Migration
  def change
    remove_column :bug_tracks, :created_by
    remove_column :bug_tracks, :updated_by
    remove_column :bug_tracks, :remark
    remove_column :bug_tracks, :bug_config_id
  end
end
