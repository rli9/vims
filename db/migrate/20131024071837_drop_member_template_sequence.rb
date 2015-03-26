class DropMemberTemplateSequence < ActiveRecord::Migration
  def change
    drop_table 'member_template_sequences'
  end
end
