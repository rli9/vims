class TestCaseStatusType < ActiveRecord::Base
  has_many :test_cases
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.active
    @active ||= find_by_name('active')
  end
end