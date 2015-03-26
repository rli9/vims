class CreateBugTracks < ActiveRecord::Migration
  def self.up
    create_table :bug_tracks do |t|
      t.integer "test_target_id", :null => false
      t.integer "bug_id", :null => false
      t.integer "test_case_id", :null => false
      t.string "remark", :null => true
      t.integer "created_by", :null => false
      t.integer "updated_by", :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
  
  def self.down
    drop_table :bug_tracks
  end
end
