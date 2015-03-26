class BugTrack < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :test_target
  belongs_to :bug

  validates_uniqueness_of :test_case_id, scope: :bug_id
  validates :test_target_id, :test_case_id, :bug_id, presence: true

  def test_case_name
    self.test_case_id ? self.test_case.name : ''
  end

  def test_case_name=(test_case_name)
    @test_case_name = test_case_name

    test_case = TestCase.find_by(name: test_case_name)

    if test_case
      self.test_case_id = test_case.id
      self.test_target_id = test_case.test_target_id
    end
  end
end
