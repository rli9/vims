class TestResult < ActiveRecord::Base
  belongs_to :test_target_instance
  belongs_to :test_case
  after_save :on_after_save

  validates_numericality_of :test_case_id, :only_integer => true
  validates_numericality_of :value, :only_integer => true
  validates_numericality_of :created_by, :only_integer => true
  validates_numericality_of :updated_by, :only_integer => true
  validates_numericality_of :test_target_instance_id, :only_integer => true

  scope :in_test_target_instance, lambda {|test_case_ids, test_target_instance| where(:test_case_id => test_case_ids, :test_target_instance_id => test_target_instance.id)}

  TEST_RESULTS = {test_target_not_run: 0b0,
                  test_target_pass: 0b1,
                  test_target_fail: 0b10,
                  test_case_fail: 0b1000}

  TEST_STATUSES = {test_target_new_pass: TEST_RESULTS[:test_target_pass],
                   test_target_new_fail: TEST_RESULTS[:test_target_fail],
                   test_target_fix: (TEST_RESULTS[:test_target_fail] << 5) | TEST_RESULTS[:test_target_pass],
                   test_target_regression: (TEST_RESULTS[:test_target_pass] << 5) | TEST_RESULTS[:test_target_fail],
                   test_target_keep_pass: (TEST_RESULTS[:test_target_pass] << 5) | TEST_RESULTS[:test_target_pass],
                   test_target_keep_fail: (TEST_RESULTS[:test_target_fail] << 5) | TEST_RESULTS[:test_target_fail],}
  TEST_TARGET_NOT_RUN = 0b0
  TEST_TARGET_PASS = 0b1
  TEST_TARGET_FAIL = 0b10
  TEST_CASE_FAIL = 0b1000

  TEST_TARGET_NEW_PASS = TEST_TARGET_PASS
  TEST_TARGET_NEW_FAIL = TEST_TARGET_FAIL
  TEST_TARGET_FIX = (TEST_TARGET_FAIL << 5) | TEST_TARGET_PASS
  TEST_TARGET_REGRESSION = (TEST_TARGET_PASS << 5) | TEST_TARGET_FAIL
  TEST_TARGET_KEEP_PASS = (TEST_TARGET_PASS << 5) | TEST_TARGET_PASS
  TEST_TARGET_KEEP_FAIL = (TEST_TARGET_FAIL << 5) | TEST_TARGET_FAIL

  def self.test_target_instances(test_results)
    TestTargetInstance.find(self.test_target_instance_ids(test_results))
  end

  def self.test_target_instance_ids(test_results)
    test_results.collect(&:test_target_instance_id).uniq
  end

  def self.stats(test_results)
    statuses = [:test_target_pass?, :test_target_fail?, :test_case_fail?, :test_target_unexecuted?]
    stats = Hash[statuses.collect {|status| [status.to_s.chomp('?').to_sym,
                                            test_results.inject(0) {|n, test_result| test_result.send(status) ? n + 1 : n}]}]

    stats[:pass_rate] = stats[:test_target_pass].to_f / (stats[:test_target_pass] + stats[:test_target_fail]) * 100

    stats
  end

  def stats_test_results(test_results)
    test_results.inject(0) {|acc, test_result| acc | test_result.value}
  end

  def self.create?(test_case, test_target_instance, test_target_pass, test_target_fail, test_case_fail)

    test_result = TestResult.new(:test_target_pass => test_target_pass, :test_target_fail => test_target_fail,
                                 :test_case_fail => test_case_fail,
                                 :test_case => test_case, :test_target_instance => test_target_instance)
    test_result.save
  end
  def to_s

    "[#{self.test_case.name}, value [#{self.value}]]"
  end

  def test_target_unexecuted
    test_target_unexecuted? ? 1 : 0
  end

  [:test_target_pass, :test_target_fail, :test_case_fail].each do |key|
    define_method "#{key}?" do
      self.value == TestResult.const_get(key.to_s.upcase.to_sym)
    end
  end

  def test_target_unexecuted?
    self.value == 0b0
  end

  def on_after_save
    weighted_test_result = WeightedTestResult.where(:test_case_id => self.test_case_id, :test_target_instance_id => self.test_target_instance_id).first
    if weighted_test_result.nil?
      weighted_test_result = WeightedTestResult.new
      weighted_test_result.test_case_id = self.test_case_id
      weighted_test_result.test_target_instance_id = self.test_target_instance_id
      weighted_test_result.value = self.value
    else
      test_results = TestResult.where(:test_case_id => self.test_case_id, :test_target_instance_id => self.test_target_instance_id)
      weighted_test_result.value = test_results.inject(0) {|acc, test_result| acc | test_result.value.to_i}
    end
    weighted_test_result.save

    weighted_test_result = WeightedTestResult.where(:test_case_id => self.test_case_id, :test_target_instance_id => self.test_target_instance_id).first
    if weighted_test_result.nil?
      weighted_test_result = WeightedTestResult.new
      weighted_test_result.test_case_id = self.test_case_id
      weighted_test_result.test_target_instance_id = self.test_target_instance_id
      weighted_test_result.value = self.value
    else
      test_results = TestResult.where(:test_case_id => self.test_case_id, :test_target_instance_id => self.test_target_instance_id)
      weighted_test_result.value = test_results.inject(0) {|acc, test_result| acc | test_result.value.to_i}
    end
    weighted_test_result.save
  end

  def on_after_destroy
    stats = stats_test_results(TestResult.where(:test_case_id => self.test_case_id, :test_target_instance_id => self.test_target_instance_id))

    weighted_test_result = self.weighted_test_result

    if weighted_test_result
      weighted_test_result.set_test_result(stats)
      weighted_test_result.save
    end

    stats = stats_test_results(TestResult.where(test_target_instance_id: self.test_target_instance_id, test_case_id: self.test_case_id))

    weighted_test_result = self.weighted_test_result

    weighted_test_result.set_test_result(stats)
    weighted_test_result.save
  end

  def weighted_test_result
    WeightedTestResult.find_by_test_target_instance_id_and_test_case_id(self.test_target_instance_id, self.test_case_id)
  end

  def self.create_all(test_case_ids, test_target_instance, value, member_id)
    sql_insert_partial = " #{test_target_instance.id}, #{value}, NOW(), NOW(), #{member_id}, #{member_id}"
    sql_insert = test_case_ids.collect {|test_case_id| "(#{test_case_id}, #{sql_insert_partial})" }
    ActiveRecord::Base.connection.execute("INSERT INTO `test_results` (`test_case_id`, `test_target_instance_id`, `value`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES #{sql_insert.join(',')}")
  end

end