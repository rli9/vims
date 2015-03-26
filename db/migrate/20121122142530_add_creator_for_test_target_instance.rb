class AddCreatorForTestTargetInstance < ActiveRecord::Migration
  def self.up
    add_column("test_target_instances", "created_by", :integer, :default => nil)
    add_column("test_target_instances", "updated_by", :integer, :default => nil) 
    
    puts "start add creator for test target instance ... "
    test_cycles = TestCycle.find_by_sql("SELECT * FROM swqd.test_cycles")
    test_cycles.each do |test_cycle|
      test_target_instance = test_cycle.test_target_instance
      test_target_instance.created_by = test_cycle.created_by
      test_target_instance.updated_by = test_cycle.updated_by
      sql = "UPDATE `swqd`.`test_target_instances` SET "
      sql = sql + "`created_by` = #{test_target_instance.created_by} " if !test_target_instance.created_by.nil?
      sql = sql + ", `updated_by` = #{test_target_instance.updated_by} " if !test_target_instance.updated_by.nil?
      sql = sql + " WHERE `id` = #{test_target_instance.id}"
      ActiveRecord::Base.connection.execute(sql)
    end   
  end
  
  def self.down
    remove_column("test_target_instances", [:created_by, :updated_by])
  end

end