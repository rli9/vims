class CreateDeviceItemDeviceItemAssociations < ActiveRecord::Migration
  def up
    create_table :device_item_device_item_associations do |t|
      t.integer "parent_device_item_id", :null => false
      t.integer "child_device_item_id", :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def down
    drop_table :device_item_device_item_associations
  end
end
