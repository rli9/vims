require 'test_helper'

class TestSuitesControllerTest < ActionController::TestCase
  def setup

  end

  def test_create_test_suite_in_root
    post :create, {:test_suite => {:name => "added_test_suite1" }, :test_target_id => test_targets(:one).id },
                  {:member_id => members(:one).id, :project_id => projects(:one).id}
    assert_response :redirect
    assets_create_test_suites("added_test_suite1", test_targets(:one).id)

  end

#need update
  # def test_user_could_not_add_existed_test_suite_in_root
    # post :create,
    #{:test_suite => {:name => "added_test_suite1"}, :test_target_id => test_targets(:one).id },
    #{:member_id => members(:one).id, :project_id => projects(:one).id}
     # post :create,
    #{:test_suite => {:name => "added_test_suite1"}, :test_target_id => test_targets(:one).id },
    #{:member_id => members(:one).id, :project_id => projects(:one).id}
    # assert_response :redirect
    # assets_create_test_suites("added_test_suite1", test_targets(:one).id)
  # end

  # def test_user_could_not_add_existed_test_suite_for_same_parent
    # post :create,
    #{:test_suite => {:name => test_suites(:two).name}, :parent_test_suite_ids => [test_suites(:one).id], :test_target_id => test_targets(:one).id  },
    #{:member_id => members(:one).id, :project_id => projects(:one).id}
#
    # post :create,
    #{:test_suite => {:name => test_suites(:two).name}, :parent_test_suite_ids => [test_suites(:one).id], :test_target_id => test_targets(:one).id  },
    #{:member_id => members(:one).id, :project_id => projects(:one).id}
    # assert_response :success
    # assert_equal(flash[:notice], "The suite name has already in same suite")
  # end

  # def test_create_test_suite_and_add_association
    # post :create, {:test_suite => {:name => "child_test_suites" }, :parent_test_suite_ids => [test_suites(:one).id], :test_target_id => test_targets(:one).id  },
                  # {:member_id => members(:one).id, :project_id => projects(:one).id}
    # assert_response :redirect
    # child_test_suites = TestSuite.where(name: "child_test_suites", test_target_id: test_targets(:one).id)
    # assets_add_test_suites_test_suites_association(test_suites(:one).id, child_test_suites[0].id)
  # end

  def assets_add_test_suites_test_suites_association(parent_test_suite_id, child_test_suite_id)
	  test_suites_test_suites_associations = TestSuitesTestSuites.where(parent_test_suite_id: parent_test_suite_id, child_test_suite_id: child_test_suite_id)
	  assert_equal(1, test_suites_test_suites_associations.size)
	  assert_equal(parent_test_suite_id, test_suites_test_suites_associations.first.parent_test_suite_id)
	  assert_equal(child_test_suite_id, test_suites_test_suites_associations.first.child_test_suite_id)
  end

  def assets_create_test_suites(test_suite_name, test_target_id)
	test_suites = TestSuite.where(name: test_suite_name, test_target_id: test_target_id)
	assert_equal(1, test_suites.size)
	assert_equal(test_suite_name, test_suites.first.name)
	assert_equal(test_target_id, test_suites.first.test_target_id)
  end
end
