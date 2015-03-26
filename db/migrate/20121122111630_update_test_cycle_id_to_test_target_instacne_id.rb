class UpdateTestCycleIdToTestTargetInstacneId < ActiveRecord::Migration
  def self.up
    test_target_instance_role_associations = TestCycleRoleAssociation.find_by_sql("SELECT * FROM swqd.test_cycle_role_associations")
    puts "start change test_target_instance_id to be test_target_instance_id !"
    test_target_instance_role_associations.each do |association|
      test_target_instance_id = association.test_cycle.test_target_instance_id
      association.test_cycle_id = test_target_instance_id 
      puts "update #{association.id} successfully !" if ActiveRecord::Base.connection.execute("UPDATE `swqd`.`test_cycle_role_associations` SET `test_cycle_id` = #{association.test_cycle_id} WHERE `id` = '#{association.id}';")
    end
    rename_column("test_cycle_role_associations", "test_cycle_id", "test_target_instance_id")
  end
  
  def self.down
    rename_column("test_cycle_role_associations", "test_target_instance_id", "test_cycle_id")
  end
end