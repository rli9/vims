class Project < ActiveRecord::Base
  has_and_belongs_to_many :members

  has_one :test_target
  has_many :test_target_instances

  belongs_to :creator, :class_name => 'Member', :foreign_key => 'created_by'

  validates_uniqueness_of :name
  validates_length_of :name, :within => 1..255

  validates_numericality_of :created_by, :only_integer => true
  validates_numericality_of :updated_by, :only_integer => true

  def created_by?(member)
    self.created_by == member
  end

  def deletable?
    self.test_target.test_target_instances.empty?
  end
end
