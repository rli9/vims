class RenameTableTestCycleRoleAssociations < ActiveRecord::Migration
 def self.up
   #After change table name, we also changed class TestCycleRoleAssociation to be TestTargetInstanceRoleAssociation
   rename_table("test_cycle_role_associations", "test_target_instance_role_associations")
 end
 
 def self.down
   rename_table("test_target_instance_role_associations", "test_cycle_role_associations")
 end

end