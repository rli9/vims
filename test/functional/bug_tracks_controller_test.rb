require 'test_helper'

class BugTracksControllerTest < ActionController::TestCase
  # def test_create_by_test_case_names_with_none_existed_test_case_name
    # create_by_test_case_names(__LINE__, test_targets(:one), members(:one), projects(:one), "wrong_test_case1")
    # assert_response :redirect
    # assert_equal("1 test cases mapping fails: wrong_test_case1", flash[:notice])
  # end
#
  # def test_create
    # bug_id = __LINE__
#
    # bug_tracks = BugTrack.where(test_case_id: test_cases(:one).id, bug_id: bug_id)
#
    # post :create, {bug_track: {:test_case_id => test_cases(:one).id, :test_target_id => test_targets(:one).id, bug_id: bug_id}},
                  # {member_id: members(:one).id, project_id: projects(:one).id, :test_target_id => test_targets(:one).id}
    # assert_response :redirect
    # assert_create_bug_tracks(test_cases(:one).id, test_targets(:one).id, bug_id)
    # assert_equal("New Bug Add Successful", flash[:notice])
  # end
#
  # def test_create_by_test_case_names
    # bug_id = __LINE__
    # create_by_test_case_names(bug_id, test_targets(:one), members(:one), projects(:one), test_cases(:one).name)
#
    # assert_response :redirect
    # assert_create_by_test_case_names_successful(test_targets(:one).id, bug_id, test_cases(:one))
    # assert_equal(flash[:notice], "Mapping test cases and bug id successfully !!")
  # end
#
  # def test_add_existed_one_test_cases_to_one_bug_tracks_by_name
    # bug_id = __LINE__
#
    # create_by_test_case_names(bug_id, test_targets(:one), members(:one), projects(:one), test_cases(:one).name)
    # create_by_test_case_names(bug_id, test_targets(:one), members(:one), projects(:one), test_cases(:one).name)
    # assert_response :redirect
    # assert_create_by_test_case_names_successful(test_targets(:one).id, bug_id, test_cases(:one))
    # assert_equal("1 test cases mapping fails: test_case_1", flash[:notice])
  # end
#
  # def test_create_by_test_case_names_with_multiple_test_case_names
    # bug_id = __LINE__
#
    # create_by_test_case_names(bug_id, test_targets(:one), members(:one), projects(:one), [test_cases(:one), test_cases(:two), test_cases(:three)].map(&:name))
#
    # assert_response :redirect
    # assert_create_by_test_case_names_successful(test_targets(:one).id, bug_id, test_cases(:one), test_cases(:two), test_cases(:three))
    # assert_equal(flash[:notice], "Mapping test cases and bug id successfully !!")
  # end
#
  # def test_not_find_test_cases_by_name
    # create_by_test_case_names(__LINE__, test_targets(:one), members(:one), projects(:one), [test_cases(:one), test_cases(:two), test_cases(:three)].map(&:name), "wrong_test_case_name2")
    # assert_response :redirect
    # assert_equal(flash[:notice], "1 test cases mapping fails: wrong_test_case_name2")
  # end
#
  # def create_by_test_case_names(bug_id, test_target, member, project, *test_case_names)
    # post :create_by_test_case_names,
         # {bug_track: {test_case_names: test_case_names.flatten.join("\r\n"), bug_id: bug_id}},
         # {member_id: member.id, project_id: project.id, test_target_id: test_target.id}
  # end
#
  # def assert_create_by_test_case_names_successful(test_target_id, bug_id, *test_cases)
    # bug_tracks = BugTrack.where(bug_id: bug_id, test_target_id: test_target_id)
#
    # assert_equal(test_cases.size, bug_tracks.size)
    # assert_equal bug_tracks.map(&:test_case).sort, test_cases.sort
  # end
#
  # def assert_create_bug_tracks(test_case_id, test_target_id, bug_id)
    # bug_tracks = BugTrack.where(test_case_id: test_case_id, test_target_id: test_target_id, bug_id: bug_id)
    # assert_equal(1, bug_tracks.size)
    # assert_equal(test_case_id, bug_tracks.first.test_case_id)
    # assert_equal(test_target_id, bug_tracks.first.test_target_id)
    # assert_equal(bug_id, bug_tracks.first.bug_id)
  # end

end
