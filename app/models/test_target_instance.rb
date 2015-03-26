class TestTargetInstance < ActiveRecord::Base
  belongs_to :test_target
  #FIXME redesign change list
  belongs_to :change_list
  belongs_to :creator, :class_name => 'Member', :foreign_key => 'created_by'

  has_many :test_results, :dependent => :delete_all
  has_many :weighted_test_results, :dependent => :delete_all

  validates_presence_of :name
  validates_presence_of :test_target_id
  validates_numericality_of :test_target_id, :only_integer => true

  validates_presence_of :change_list_id
  validates_numericality_of :change_list_id

  validates_numericality_of :created_by, :only_integer => true
  validates_numericality_of :updated_by, :only_integer => true

  validates_uniqueness_of :name, :scope => :test_target_id

  validates_length_of :test_target_id, :maximum => 11
  validates_length_of :change_list_id, :maximum => 11

  def previous_test_target_instances
    TestTargetInstance.where(test_target_id: self.test_target_id).where("change_list_id < ?", self.change_list_id).order('change_list_id DESC')
  end

  def previous_test_target_instance
    previous_test_target_instances.first
  end

  # executed test cases
  def test_cases
    #FIXME should equal to weighted_test_results.collect {|test_case|}
    self.test_results.collect(&:test_case).uniq.select {|test_case| test_case.active?}
  end

  def latest_weighted_test_results_until(test_target_instance)
    self.test_cases.collect {|test_case| test_case.latest_weighted_test_result_until(test_target_instance)}
  end

  def weighted_test_results_before
    latest_weighted_test_results_until(self.previous_test_target_instance)
  end

  def deletable?
    !TestResult.exists?(:test_target_instance_id => self.id) && !TestTargetInstance.exists?(:test_target_instance_id => self.id)
  end

end
