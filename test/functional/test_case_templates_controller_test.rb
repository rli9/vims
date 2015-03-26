require 'test_helper'

class TestCaseTemplatesControllerTest < ActionController::TestCase
  def setup
    session[:member_id] = members(:one).id
  end
  
  def test_create
    post :create, :test_case_template => {:name => 'test', :test_target_id => test_targets(:one).id}
    assert_response :redirect
    
    test_case_template = TestCaseTemplate.find_by_name_and_test_target_id('test', test_targets(:one).id)
    assert_not_nil test_case_template
  end
end
