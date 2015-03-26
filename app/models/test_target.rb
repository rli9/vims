class TestTarget < ActiveRecord::Base
  has_many :test_cases, :dependent => :destroy
  has_many :test_suites, :dependent => :destroy
  has_many :test_target_instances, :dependent => :destroy
  has_many :test_case_templates, :dependent => :destroy
  has_many :bug_tracks
  has_one :bug_config

  belongs_to :project

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_length_of :name, :maximum => 255, :allow_nil => false

  def latest_test_target_instance
    self.test_target_instances.sort_by {|item| item.change_list_id}.last
  end

  def deletable?
    self.test_target_instances.empty? && self.test_cases.empty? && self.test_suites.empty?
  end

  def top_test_suites
    TestSuite.top_test_suites(self.test_suites)
  end

  def bug_tracker_url
    self.bug_config ? self.bug_config.url : ""
  end
end
