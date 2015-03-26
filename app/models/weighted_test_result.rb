class WeightedTestResult < ActiveRecord::Base
  belongs_to :test_target_instance
  belongs_to :test_case

  validates_numericality_of :test_target_instance_id, :only_integer => true
  validates_numericality_of :test_case_id, :only_integer => true
  validates_numericality_of :value, :only_integer => true, :greater_than_or_equal_to => 0

  validates_uniqueness_of :test_case_id, :scope => :test_target_instance_id

  def save_on_value_change(new_value)
    self.value = new_value
    self.save
  end

  def test_target_unexecuted
    test_target_unexecuted? ? 1 : 0
  end

  def test_target_unexecuted?
    self.value == 0
  end

  [:test_target_pass, :test_target_fail, :test_case_fail].each do |key|
    define_method "#{key}?" do
      value = TestResult.const_get(key.to_s.upcase.to_sym)
      (self.value & ((value << 1) - 1)) == value
    end
  end

  def deduced_value
    (self.value & TestResult::TEST_TARGET_PASS != 0) ? TestResult::TEST_TARGET_PASS :
    ((self.value & TestResult::TEST_CASE_FAIL != 0) ? TestResult::TEST_CASE_FAIL : TestResult::TEST_TARGET_FAIL)
  end

  def test_status(prev_weighted_test_result = nil)
    prev_weighted_test_result_value = (prev_weighted_test_result && prev_weighted_test_result.value != TestResult::TEST_CASE_FAIL) ? prev_weighted_test_result.value : TestResult::TEST_TARGET_NOT_RUN
    self.value == TestResult::TEST_CASE_FAIL ? TestResult::TEST_CASE_FAIL : ((prev_weighted_test_result_value << 5) | self.value)
  end

  def self.test_target_instances(test_results)
    TestTargetInstance.find(test_results.collect(&:test_target_instance_id).uniq)
  end

  def self.test_target_instance_ids(test_results)
    test_results.collect(&:test_target_instance_id).uniq
  end

  def self.in_test_target_instance(test_case_ids, test_target_instance)
    self.where(:test_target_instance_id => test_target_instance.id, :test_case_id => test_case_ids)
  end

  def self.where_condition(test_case_ids, test_target_instance)
    {:test_target_instance_id => test_target_instance.id, :test_case_id => test_case_ids}
  end
end
