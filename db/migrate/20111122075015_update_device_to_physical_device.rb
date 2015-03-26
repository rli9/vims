class UpdateDeviceToPhysicalDevice < ActiveRecord::Migration
  def up
    change_column(:device_items, :device_id, :integer, :null => true)
    rename_table("devices", "physical_device_models")
    rename_column("device_items", "device_id", "physical_device_model_id")
    add_column :device_items, :name, :string
    add_column :device_items, :type, :string
      DeviceItem.find_each do |device_item|
        device_item.type = "PhysicalDeviceItem"
        device_item.save
      end
  end

  def down
    rename_table("physical_device_models", "devices")
    rename_column("device_items", "physical_device_model_id", "device_id")
    remove_column :device_items, :name
    remove_column :device_items, :type
    change_column(:device_items, :device_id, :integer, :null => false)
  end
end