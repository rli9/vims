class DropTables2 < ActiveRecord::Migration
  def change
    drop_table 'test_case_hsd_nonassociations'
    drop_table 'test_case_hsd_nonassociation_types'
    drop_table 'weighted_target_instance_results'
    drop_table 'device_transactions'
    drop_table 'hw_configs'
    drop_table 'page_hierarchies'
    drop_table 'sw_configs'
    drop_table 'test_case_step_phases'
  end
end
