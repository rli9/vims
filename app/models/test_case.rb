class TestCase < ActiveRecord::Base
  #has_and_belongs_to_many :test_suites

  has_many :weighted_test_results, :dependent => :delete_all
  has_many :test_results, :dependent => :delete_all
  has_many :bug_tracks, :dependent => :delete_all

  belongs_to :test_target

  validate :name, :presence => true
  validates_uniqueness_of :name, :scope => :test_target_id

  validate :test_target_id, :presence => true
  validates_numericality_of :test_target_id, :only_integer => true

  def test_case_test_result
    TestResult.where(["test_case_id = ?", self.id]).last
  end

  def test_case_current_build_test_result(test_target_instance)
    self.weighted_test_results.select {|result| result.test_target_instance_id == test_target_instance.id}.first
  end

  def deletable?
    self.unexecuted?
  end

  def unexecuted?
    self.test_results.empty?
  end

  def first_test_suite
    self.test_suites.empty? ? self.test_target.test_suites.first : self.test_suites.first
  end

  def self.search(test_cases, key_words)
    key_words = Regexp.escape(key_words).downcase
    test_cases.select {|test_case| test_case.name.downcase.match(key_words)}
  end

  def test_suite_ids
    self.test_suites.collect(&:test_suite_id)
  end

  def test_suite
    self.test_suites.first
  end

  #FIXME
  def test_suites_names
    self.test_suites.collect(&:name).join('/')
  end

  #FIXME should return true/false
  def belongs_to_test_suite?(test_suite)
    self.test_suites.detect {|self_test_suite| self_test_suite == test_suite}
  end

  def belongs_to_test_case_template_param_instance?(test_case_template_param_instance)
    self.test_case_template_param_instances.detect {|self_template_instance| self_template_instance == test_case_template_param_instance}
  end

  def top_test_suites
    TestSuite.top_test_suites(self.test_suites)
  end

  def to_s
    "<#{self.name}>"
  end

  def latest_weighted_test_result_until(test_target_instance)
    unless test_target_instance.nil?
      weighted_test_results = self.weighted_test_results.
                                   select {|weighted_test_result| weighted_test_result.test_target_instance.change_list_id <= test_target_instance.change_list_id}.
                                   sort {|x, y| y.test_target_instance.change_list_id <=> x.test_target_instance.change_list_id}

      weighted_test_result = weighted_test_results.detect {|weighted_test_result| weighted_test_result.test_target_pass? || weighted_test_result.test_target_fail?}
      weighted_test_result = weighted_test_results.first if weighted_test_result.nil?
    end

    unless weighted_test_result
      weighted_test_result = WeightedTestResult.empty_new
      weighted_test_result.test_case = self
    end

    weighted_test_result
  end

  def test_case_max_depth
    case_max_suite_depth = 0
    current_test_case_test_suites = self.test_suites

    if current_test_case_test_suites
      current_test_case_test_suites.each do |case_suite|
        case_suite_depth = case_suite.current_test_suite_depth
        case_max_suite_depth = case_suite_depth if case_suite_depth > case_max_suite_depth
      end
    end
    case_max_suite_depth
  end

  def top_test_suite_name
    suite_name = "NULL"
    test_suite = self.find_test_suite_of_test_case
    if test_suite
      suite_name = test_suite.recursive_top_test_suite.name
    end
    suite_name
  end

  def recursive_test_case_test_suites
    test_suite = self.find_test_suite_of_test_case
    if test_suite.parent_test_suites
      recursive_test_suites = test_suite.recursive_parent_test_suites
    end
    recursive_test_suites.insert(0, test_suite).reverse!
    recursive_test_suites
  end

  def self.batch_delete_all(test_cases)
    return if test_cases.nil? || test_cases.empty?

    test_case_ids = test_cases.map(&:id)

    BugTrack.where('test_case_id in (?)', test_case_ids).delete_all
    TestResult.where('test_case_id in (?)', test_case_ids).delete_all
    WeightedTestResult.where('test_case_id in (?)', test_case_ids).delete_all
    ActiveRecord::Base.connection.execute("delete from test_cases_suites where test_case_id in (#{test_case_ids.join(',')})")

    self.where('id in (?)', test_case_ids).delete_all
  end

  def self.batch_update_name(test_target_id, prev_raw_test_case_names)
    prev_raw_test_case_names.every(50) do |partial_prev_raw_test_case_names|
      prev_test_case_names_curr_test_case_names = partial_prev_raw_test_case_names.map do |prev_raw_test_case_name|
        curr_raw_test_case_name = prev_raw_test_case_name.clone
        yield curr_raw_test_case_name

        [prev_raw_test_case_name.join("_"), curr_raw_test_case_name.join("_")]
      end
      prev_test_case_names_curr_test_case_names = Hash[prev_test_case_names_curr_test_case_names]

      test_cases = TestCase.where('test_target_id = ? and name in (?)', test_target_id, prev_test_case_names_curr_test_case_names.keys).select('id, name')

      unless test_cases.empty?
        sql = test_cases.map {|test_case| "when #{test_case.id} then '#{prev_test_case_names_curr_test_case_names[test_case.name]}'"}.join(' ')
        ActiveRecord::Base.connection.execute("update test_cases set name = case id #{sql} end where id in (#{test_cases.map(&:id).join(',')})")
      else
        puts "****************************"
        puts prev_test_case_names_curr_test_case_names.keys
      end
    end
  end

  def self.update_test_case_names(column_name, append_name, test_case_ids)
    ActiveRecord::Base.connection.execute("update `test_cases` SET #{column_name} = REPLACE(#{column_name}, CONCAT(#{column_name}), CONCAT(#{column_name}, '_', '#{append_name}')) where id in (#{test_case_ids.join(',')})")
  end
end
