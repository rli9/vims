require 'test_helper'

class TestTargetInstancesControllerTest < ActionController::TestCase
  def setup
    session[:member_id] = members(:one).id
    session[:project_id] = projects(:one).id
    session[:test_target_id] = test_targets(:one).id
  end

  # Case 3, no TR, no WTR
  def test_should_create_test_result
    test_target_instance = get_new_test_target_instance("example1", "2012112801")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1')
    assert_response :success
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1)
  end

  def test_should_create_test_result_case_insensitive
    test_target_instance = get_new_test_target_instance("example1", "2012112801")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'CODE_2_gen7')
    assert_response :success
    assert_test_result_valid(test_target_instance, members(:one), 'code_2_gen7', 1)
  end

  # Case 3, no TR, no WTR
  def test_should_create_test_results
    test_target_instance = get_new_test_target_instance("example2", "2012112802")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1)
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_2', 1)
  end

  # Case 1, single user, yes TR, yes WTR, value changed
  def test_single_user_should_update_test_results_under_c1
    test_target_instance = get_new_test_target_instance("example3", "2012112803")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')

    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_FAIL, 'test_case_1', 'test_case_2')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 2, 3, 2)
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_2', 2, 3, 2)
  end

  # Case 1, single user, yes TR, yes WTR, value not changed
  def test_single_user_should_keep_test_results_under_c1
    test_target_instance = get_new_test_target_instance("example4", "2012112804")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')

    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1, 1, 2)
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_2', 1, 1, 2)
  #TODO assert view
  end

  # Case 1, multiple user, yes TR, yes WTR, value changed
  def test_multiple_users_should_update_test_result_under_c1_0
    test_target_instance = get_new_test_target_instance("example5", "2012112805")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1')
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_PASS, 'test_case_1')

    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_FAIL, 'test_case_1')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:two), 'test_case_1', 0b01, 0b11)
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 0b10, 0b11, 2)
  end

  # Case 1, multiple user, yes TR, yes WTR, value changed
  def test_multiple_users_should_update_test_result_under_c1_1
    test_target_instance = get_new_test_target_instance("example6", "2012112806")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1')
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_FAIL, 'test_case_1')

    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_FAIL, 'test_case_1')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:two), 'test_case_1', 0b10, 0b11)
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 0b10, 0b11, 2)
  end

   # Case 2, mulitple users, no TR, yes WTR, value not contained in weighted.value
  def test_multiple_users_should_update_test_results_under_c2
    test_target_instance = get_new_test_target_instance("example7", "2012112807")
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_FAIL, 'test_case_1')
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:two), 'test_case_1', 0b10, 0b11)
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 0b01, 0b11)
  end

  # Case 2, mulitple users, no TR, yes WTR, value contained in weighted.value
  def test_multiple_users_should_keep_test_results_under_c2
    test_target_instance = get_new_test_target_instance("example8", "2012112808")
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_PASS, 'test_case_1')
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1')
    assert_response :success

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1)
    assert_test_result_valid(test_target_instance, members(:two), 'test_case_1', 1)
  end

  def test_single_user_delete_not_existed_test_result
    test_target_instance = get_new_test_target_instance("example9", "2012112809")
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_1')
    #assert_equal("1 test cases are not found", flash[:notice])
  end

  def test_single_user_delete_not_existed_test_results
    test_target_instance = get_new_test_target_instance("example10", "2012112810")
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_1', 'test_case_2')
    #assert_equal("1 test cases are not found", flash[:notice])
  end

  def test_single_user_delete_partly_existed_test_results
    test_target_instance = get_new_test_target_instance("example11", "2012112811")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1')
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_1', 'test_case_2')
    assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_1')
  end

  def test_user_one_delete_test_results_of_user_two
    test_target_instance = get_new_test_target_instance("example12", "2012112812")
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_FAIL, 'test_case_1', 'test_case_2')
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_1')
    assert_test_result_valid(test_target_instance, members(:two), 'test_case_1', 2)
  end

  def test_single_user_delete_passed_test_results_with_weighted_value_checked
    test_target_instance = get_new_test_target_instance("example13", "2012112813")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_2')

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1)
    assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_2')
  end

  # def test_multi_user_delete_test_results_with_weighted_values_checked_interact
    # test_target_instance = get_new_test_target_instance("example14", "2012112814")
    # batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    # batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_FAIL, 'test_case_1', 'test_case_2')
    # batch_delete_test_results(test_target_instance, members(:one), 'test_case_2')
    # batch_delete_test_results(test_target_instance, members(:two), 'test_case_1')
#
    # assert_test_result_valid(test_target_instance, members(:two), 'test_case_2', 2)
    # assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_2', 0b10)
#
    # assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1)
    # assert_delete_test_result_valid(test_target_instance, members(:two), 'test_case_1', 0b01)
#
  # end

  def test_multi_user_delete_test_results_with_weighted_values_checked_fail
    test_target_instance = get_new_test_target_instance("example15", "2012112815")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_FAIL, 'test_case_1', 'test_case_2')
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_FAIL, 'test_case_1', 'test_case_2')

    batch_delete_test_results(test_target_instance, members(:one), 'test_case_2')

    batch_delete_test_results(test_target_instance, members(:two), 'test_case_1')

    assert_test_result_valid(test_target_instance, members(:two), 'test_case_2', 2)
    assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_2', 0b10)

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 2)
    assert_delete_test_result_valid(test_target_instance, members(:two), 'test_case_1', 0b10)
  end

  def test_multi_user_delete_test_results_with_weighted_values_checked_pass
    test_target_instance = get_new_test_target_instance("example16", "2012112816")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_2')
    batch_delete_test_results(test_target_instance, members(:two), 'test_case_1')

    assert_test_result_valid(test_target_instance, members(:two), 'test_case_2', 1)
    assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_2', 0b01)

    assert_test_result_valid(test_target_instance, members(:one), 'test_case_1', 1)
    assert_delete_test_result_valid(test_target_instance, members(:two), 'test_case_1', 0b01)
  end

  def test_single_user_could_delete_test_results_self
    test_target_instance = get_new_test_target_instance("example17", "2012112817")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2', 'test_case_3')
    batch_delete_test_results(test_target_instance, members(:one), 'test_case_1', 'test_case_2')

    assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_1')
    assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_2')
    assert_test_result_valid(test_target_instance, members(:one), 'test_case_3', 1)
  end

  # def test_multiple_users_could_delete_test_results_self
    # test_target_instance = get_new_test_target_instance("example18", "2012112818")
    # batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')
    # batch_edit_test_results(test_target_instance, members(:two), TestResult::TEST_TARGET_FAIL, 'test_case_1', 'test_case_2')
#
    # batch_delete_test_results(test_target_instance, members(:one), 'test_case_1')
    # batch_delete_test_results(test_target_instance, members(:two), 'test_case_2')
    # assert_test_result_valid(test_target_instance, members(:one), 'test_case_2', 1)
    # assert_test_result_valid(test_target_instance, members(:two), 'test_case_1', 2)
#
    # assert_delete_test_result_valid(test_target_instance, members(:one), 'test_case_1', 2)
    # assert_delete_test_result_valid(test_target_instance, members(:two), 'test_case_2', 1)
  # end

  def test_delete_test_target_instance_without_test_results
    test_target_instance = get_new_test_target_instance("example19", "2012112819")
    test_target_instance_id = test_target_instance.id
    name = test_target_instance.name
    has_results = false
    assert_delete_test_results(test_target_instance_id, name, has_results)
  end

  def test_delete_test_target_instance_with_test_results
    test_target_instance = get_new_test_target_instance("example20", "2012112820")
    batch_edit_test_results(test_target_instance, members(:one), TestResult::TEST_TARGET_PASS, 'test_case_1', 'test_case_2')

    test_target_instance_id = test_target_instance.id
    name = test_target_instance.name
    has_results = true

    test_results = TestResult.where(test_target_instance_id: test_target_instance_id)
    weighted_test_results = WeightedTestResult.where(test_target_instance_id: test_target_instance_id)
    assert_equal(2, test_results.size)
    assert_equal(2, weighted_test_results.size)

    assert_delete_test_results(test_target_instance_id, name, has_results)
  end

  def test_create_test_target_instance
    create_new_test_target_instance("test_target_instance_1", "20121126")
    assert_equal(flash[:notice], "test target instance test_target_instance_1 saved successfully !")
    assert_new_test_target_instance("test_target_instance_1", "20121126")
  end

  def test_update_test_target_instance
    test_target_instance = get_new_test_target_instance("example21", "2012112821")
    post :update, {:id => test_target_instance.id, :test_target_instance => {:name => "updated_tti_name", :change_list_id => "2012112830"}}
    assert_response :redirect

    updated_test_target_instance = TestTargetInstance.find(test_target_instance.id)

    assert_equal(updated_test_target_instance.name, "updated_tti_name")
    assert_equal(updated_test_target_instance.change_list_id, 2012112830)
  end

  def assert_delete_test_results(test_target_instance_id, name, has_results)
    post :delete, {:id => test_target_instance_id}
    assert_equal(flash[:notice], "Delete #{name} successfully" )
    assert_response :redirect

    test_target_instances = TestTargetInstance.where(id: test_target_instance_id)
    assert_equal(0, test_target_instances.size)
    if has_results
      test_results = TestResult.where(test_target_instance_id: test_target_instance_id)
      weighted_test_results = WeightedTestResult.where(test_target_instance_id: test_target_instance_id)
      assert_equal(0, test_results.size)
      assert_equal(0, weighted_test_results.size)
    end
  end

  def get_new_test_target_instance(name, change_list_id)
     create_new_test_target_instance(name, change_list_id)
     TestTargetInstance.find_by_name_and_change_list_id(name, change_list_id)
  end

  def assert_new_test_target_instance(name, change_list_id)
    test_target_instances = TestTargetInstance.where(name: name, change_list_id: change_list_id)
    assert_equal(1, test_target_instances.size)
  end

  def assert_weighted_test_results(test_target_instance, size)
    weighted_test_results = WeightedTestResult.where(test_target_instance_id: test_target_instance.id)
    assert_equal(size, weighted_test_results.size)
  end

  def assert_test_target_instances(test_target_instance, size, *test_target_instance_name)
    test_target_instances = TestTargetInstance.where(test_target_instance_id: test_target_instance.id)
    assert_equal(size, test_target_instances.size)
    if size != 0
      assert_equal(test_target_instance_name[0], test_target_instances.first.name)
    end
  end

  def assert_test_results(test_target_instance, size, *value)
    test_results = WeightedTestResult.where(test_target_instance_id: test_target_instance.id)
    assert_equal(size, test_results.size)
    if size != 0
      assert_equal(value[0], test_results.first.value)
    end
  end

  def assert_delete_response(test_target_instance)
    assert_equal(flash[:notice], "Delete  #{test_target_instance.name} successfully")
    assert_response :redirect
  end

  def batch_edit_test_results(test_target_instance, member, test_result, *test_case_names)
    post :create_test_results_by_test_case_names,
         {:id => test_target_instance.id, :member_id => member.id, :test_case_names => test_case_names.join("\r\n"), test_result: {value: test_result}},
         {:member_id => member.id, :project_id => projects(:one).id}
  end

  def batch_delete_test_results(test_target_instance, member, *test_case_names)
    @member = member
    post :delete_test_results_by_test_case_names,
         {:id => test_target_instance.id, :member_id => member.id, :test_case_names => test_case_names.join("\r\n")},
         {:member_id => member.id, :project_id => projects(:one).id, :test_target_id => test_targets(:one).id}
  end

  def create_new_test_target_instance(name, change_list_id)
    post :create, {:test_target_instance => {:name => name, :change_list_id => change_list_id}},
                  {:member_id => session[:member_id], :project_id => session[:project_id], :test_target_id => session[:test_target_id]}
  end
  # def assert_test_result_invalid(member, test_case, value)
  # test_target_instance = test_target_instances(:one)
#
  # test_results = TestResult.find_all_by_test_case_id_and_test_target_instance_id_and_created_by(test_case.id, test_target_instance.id, member.id)
  # assert_equal(0, test_results.size)
  # assert_equal(value, test_results.first.value)
#
  # end

  def assert_test_result_valid(test_target_instance, member, test_case_name, value, weighted_value = nil, test_results_size = 1)
    test_case = TestCase.where(name: test_case_name, test_target_id: test_target_instance.test_target_id).first

    test_results = TestResult.where(test_case_id: test_case.id, test_target_instance_id: test_target_instance.id, created_by: member.id)
    assert_equal(test_results_size, test_results.size)

    weighted_value ||= test_results.inject {|weight_result, result| weight_result.value | result.value}.value

    weighted_test_results = WeightedTestResult.where(test_case_id: test_case.id, test_target_instance_id: test_target_instance.id)
    assert_equal(1, weighted_test_results.size)
    assert_equal(weighted_value, weighted_test_results.first.value)
  end

  def assert_delete_test_result_valid(test_target_instance, member, test_case_name, weighted_value = nil)
    test_case = TestCase.where(name: test_case_name, test_target_id: test_target_instance.test_target_id).first


    test_results = TestResult.where(test_case_id: test_case.id, test_target_instance_id: test_target_instance.id, created_by: member.id)
    assert_equal(0, test_results.size)

    weighted_test_target_instance_results = WeightedTestResult.where(test_case_id: test_case.id, test_target_instance_id: test_target_instance.id)

    unless weighted_value.nil?
      assert_equal(1, weighted_test_target_instance_results.size)
      assert_equal(weighted_value, weighted_test_target_instance_results.first.value)
    else
      assert_equal(0, weighted_test_target_instance_results.size)
    end
  end
end