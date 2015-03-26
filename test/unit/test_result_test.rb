require 'test_helper'
 
class TestResultTest < ActiveSupport::TestCase
  test "value is correct" do
    test_result = TestResult.new(:value => TestResult::TEST_TARGET_PASS)
    assert test_result.test_target_pass?
  end
  
  test "stats" do
    test_results = [TestResult.new(:value => TestResult::TEST_TARGET_PASS), 
                    TestResult.new(:value => TestResult::TEST_TARGET_FAIL)]
        
    stats = TestResult.stats(test_results)
    assert_equal 1, stats[:test_target_pass]
    assert_equal 1, stats[:test_target_fail]
    assert_equal 50, stats[:pass_rate]       
  end
end