class CreateBugConfigs < ActiveRecord::Migration
  def self.up
    create_table :bug_configs do |t|
      t.integer "test_target_id", :null => false
      t.string "url", :null => false
      t.string  "remark", :null => true
      t.integer "created_by", :null => false
      t.integer "updated_by", :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
    add_column :bug_tracks, :bug_config_id, :integer
    BugTrack.where('test_target_id = ?', 23).update_all(:bug_config_id => 1)    
  end
  
  def self.down
    remove_column :bug_tracks, :bug_config_id
    drop_table :bug_configs
  end
end
