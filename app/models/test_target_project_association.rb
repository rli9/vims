class TestTargetProjectAssociation < ActiveRecord::Base
  belongs_to :test_target
  belongs_to :project

  validates_presence_of :test_target_id
  validates_presence_of :project_id

  validates_numericality_of :test_target_id, :only_integer => true
  validates_numericality_of :project_id, :only_integer => true

  validates_length_of :test_target_id, :maximum => 11
  validates_length_of :project_id, :maximum => 11

  validates_uniqueness_of :test_target_id
  validates_uniqueness_of :project_id
end
