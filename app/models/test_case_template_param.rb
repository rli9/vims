class TestCaseTemplateParam < ActiveRecord::Base
  belongs_to :test_case_template

  validates_presence_of :name
  validates_length_of :name, :maximum => 255

  validates_presence_of :seq
  validates_numericality_of :seq, :only_integer => true
end
