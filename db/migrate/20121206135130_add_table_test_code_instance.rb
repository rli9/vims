class AddTableTestCodeInstance < ActiveRecord::Migration
  def self.up
    create_table :test_code_instances do |t|
      t.integer  :changeset, :null => false
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end

    add_index :test_code_instances, :changeset

  end

  def self.down
    drop_table :test_code_instances
  end
end