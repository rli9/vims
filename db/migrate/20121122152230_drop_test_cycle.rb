class DropTestCycle < ActiveRecord::Migration
  def self.up
    drop_table("test_cycles")
  end
   
  def self.down
    create_table("test_cycles") do |t|
      t.string "name", :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer "test_target_instance_id", :null => false
      t.integer "created_by", :default => nil
      t.integer "updated_by", :default => nil
      t.string "remark", :default => nil
    end
  end
end