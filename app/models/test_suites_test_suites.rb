class TestSuitesTestSuites < ActiveRecord::Base
  belongs_to :parent_test_suite, :class_name => "TestSuite"
  belongs_to :child_test_suite, :class_name => "TestSuite"
  
  validates_presence_of :parent_test_suite_id
  validates_presence_of :child_test_suite_id     

  validates_numericality_of :parent_test_suite_id, :only_integer => true
  validates_numericality_of :child_test_suite_id, :only_integer => true
  
  validates_uniqueness_of :parent_test_suite_id, :scope => :child_test_suite_id  
  validates_uniqueness_of :child_test_suite_id, :scope => :parent_test_suite_id    
  
  validate do |record|
    if record.parent_test_suite && record.child_test_suite
      if record.parent_test_suite.id == record.child_test_suite.id
        record.errors.add_to_base("parent_test_suite should diff w/ child_test_suite")
      end
      
      unless record.parent_test_suite.test_target.id == record.child_test_suite.test_target.id
        record.errors.add_to_base("Test target is different btw parent's and child's")
      end
      
      if record.parent_test_suite.recursive_child_test_suite_of?(record.child_test_suite)
        record.errors.add_to_base("parent_test_suite should not be recursive child of child_test_suite")
      end
    end
  end  
end
