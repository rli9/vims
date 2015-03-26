class CreateMemberTemplateSequences < ActiveRecord::Migration
  def self.up
    create_table :member_template_sequences do |t|
      t.integer "member_id", :null => false
      t.integer "test_target_id", :null => false
      t.integer "test_case_template_target_id", :null => false
      t.string "template_sequence", :null => true
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def self.down
    drop_table :member_template_sequences
  end
end
