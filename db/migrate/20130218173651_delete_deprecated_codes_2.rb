class DeleteDeprecatedCodes2 < ActiveRecord::Migration
  def up
    remove_column :test_targets, :prd_id
    drop_table("message_agents")
    drop_table("operating_systems")    drop_table("performance_benchmarks")
    drop_table("performance_profiles")
    drop_table("performance_results")
    drop_table("physical_device_models")
  end
  
  def down
  end  
end