class DropRole < ActiveRecord::Migration
  def change
    drop_table 'roles'
    drop_table 'test_target_instance_role_associations'
  end
end
