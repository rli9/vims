class TestSuite < ActiveRecord::Base
  has_and_belongs_to_many :test_cases
  has_many :parent_test_suite_test_suite_associations, :class_name => "TestSuitesTestSuites", :foreign_key => "child_test_suite_id", :dependent => :destroy
  has_many :child_test_suite_test_suite_associations, :class_name => "TestSuitesTestSuites", :foreign_key => "parent_test_suite_id", :dependent => :destroy
  has_many :parent_test_suites, :through => :parent_test_suite_test_suite_associations
  has_many :child_test_suites, :through => :child_test_suite_test_suite_associations

  belongs_to :test_target

  validates_presence_of :name
  validates_presence_of :test_target_id
  validates_numericality_of :test_target_id, :only_integer => true
  validates_length_of :test_target_id, :maximum => 11

  def deletable?
    self.test_cases.empty? && self.child_test_suites.empty?
  end

  def test_suite_id
    self.id
  end

  def find_test_cases(options)
    unless options.nil?
      test_case_ids = self.test_cases.collect(&:id)
      TestCase.find(test_case_ids, options)
    else
      self.test_cases
    end
  end

  def self.top_test_suites(test_suites)
    test_suites.select {|test_suite| test_suite.parent_test_suites.empty?}
  end

  def parent_test_suite_of?(test_suite)
    self.child_test_suites.detect {|child_test_suite| child_test_suite == test_suite}
  end

  def child_test_suite_of?(test_suite)
    self.parent_test_suites.detect {|child_test_suite| child_test_suite == test_suite}
  end

  def recursive_child_test_suite_of?(test_suite)
    if self.child_test_suite_of?(test_suite)
      return test_suite
    else
      test_suite.child_test_suites.each do |child_test_suite|
        child_test_suite_of = recursive_child_test_suite_of?(child_test_suite)
        return child_test_suite_of if child_test_suite_of
      end
    end
    nil
  end

  def recursive_child_test_suites
    recursive = self.child_test_suites.clone
    recursive.concat(self.child_test_suites.collect(&:recursive_child_test_suites).flatten)
    recursive.uniq
  end

  def recursive_parent_test_suites
    recursive = self.parent_test_suites.clone
    recursive.concat(self.parent_test_suites.collect(&:recursive_parent_test_suites).flatten)
    recursive.uniq
  end

  def latest_version_test_cases(options = nil)
    self.test_cases(options)
  end

  def latest_version_active_test_cases(options = nil)
    self.test_cases(options)
  end

  def total_recursive_latest_version_active_test_cases
    total_cases_size = self.latest_version_active_test_cases.size
    unless self.child_test_suites.empty?
      self.child_test_suites.each do |child_test_suite|
        total_cases_size = total_cases_size + child_test_suite.total_recursive_latest_version_active_test_cases
      end
    end
    total_cases_size
  end

  def recursive_latest_version_active_test_cases
    total_cases = self.latest_version_active_test_cases
    unless self.child_test_suites.empty?
      self.child_test_suites.each do |child_test_suite|
        total_cases = total_cases.concat(child_test_suite.recursive_latest_version_active_test_cases)
      end
    end
    total_cases
  end

  def max_recursive_child_test_suite_depth
    max_depth = 0

    unless self.child_test_suites.empty?
      self.child_test_suites.each do |child_test_suite|
        depth = 1 + child_test_suite.max_recursive_child_test_suite_depth
        max_depth = depth if depth > max_depth
      end
    end
    max_depth
  end

  def current_test_suite_depth
    current_depth = 0
    unless self.parent_test_suites.empty?
      self.parent_test_suites.each do |parent_test_suite|
        depth = 1 + parent_test_suite.current_test_suite_depth
        current_depth = depth if depth > current_depth
      end
    end
    current_depth
  end

  def test_suite_max_depth
    max_suite_depth = 0

    unless self.parent_test_suites.empty?
      self.parent_test_suites.each do |parent_test_suite|
        suite_depth = parent_test_suite.current_test_suite_depth
        max_suite_depth = suite_depth if suite_depth > max_suite_depth
      end
    end
    max_suite_depth
  end

  def recursive_top_test_suite
    top_suite = self
    unless self.parent_test_suites.empty?
      self.parent_test_suites.each do |parent_test_suite|
        top_suite = parent_test_suite
      end
    end
    top_suite
  end

end
