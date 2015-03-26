class DeleteDeprecatedCodes < ActiveRecord::Migration
  def up
    remove_column :test_cases, :type, :test_execution_type_id, :video_codec_id, :video_player_id, 
                               :video_entry_id, :video_clip_id, :test_case_priority_id
    drop_table("hufs")
    drop_table("huf_items")
    drop_table("huf_item_forecasts")
    drop_table("basic_io_systems")
    drop_table("code_files")
    drop_table("device_categories")
    drop_table("device_items")
    drop_table("device_roles")
    drop_table("device_item_device_item_associations")
    drop_table("device_item_statuses")
    drop_table("device_item_usage_tags")
    drop_table("device_transaction_status_types")
    drop_table("embedded_controllers")
    drop_table("hsd_resolve_change_list_associations")
    drop_table("hsd_resolve_member_associations")
    drop_table("hsd_resolves")
    drop_table("test_execution_types")
    drop_table("test_case_priorities")
  end
  
  def down
  end  
end