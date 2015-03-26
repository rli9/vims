require 'test_helper'

class TestCaseTemplateParamsControllerTest < ActionController::TestCase
  def setup
    session[:member_id] = members(:one).id
    session[:project_id] = projects(:one).id
    session[:test_target_id] = test_targets(:one).id
  end

  def test_create
    create(name: 'test', test_case_template_id: test_case_templates(:one).id)
    assert_response :redirect

    assert_test_case_template_param_created('test', test_case_templates(:one).id) do |test_case_template_param, test_case_template_param_instance|
      assert_equal test_case_template_param.seq, 0
    end
  end

  def test_create_2nd_test_case_template_param
    create(name: 'test1', test_case_template_id: test_case_templates(:one).id)
    create(name: 'test2', test_case_template_id: test_case_templates(:one).id)
    assert_response :redirect

    assert_test_case_template_param_created('test1', test_case_templates(:one).id) do |test_case_template_param_0, test_case_template_param_instance_0|
      assert_equal test_case_template_param_0.seq, 0

      assert_test_case_template_param_created('test2', test_case_templates(:one).id) do |test_case_template_param_1, test_case_template_param_instance_1|
        assert_equal test_case_template_param_1.seq, 1
      end
    end
  end

  # 1 param with 1 instance, 2 params
  # def test_move_up_1_1
    # create(name: 'test1', test_case_template_id: test_case_templates(:one).id)
    # create(name: 'test2', test_case_template_id: test_case_templates(:one).id)
#
    # test_case_template_param_0 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test1', test_case_templates(:one).id)
    # test_case_template_param_1 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test2', test_case_templates(:one).id)
    # pre_test_case_id = TestCase.find_by_name(test_case_templates(:one).name.scan(/\w+/).join('_') + "_#{test_case_template_param_0.id}_#{test_case_template_param_1.id}").id
#
    # post :move_up, id: test_case_template_param_1.id
    # assert_response :redirect
#
    # test_case_template_param_0 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test1', test_case_templates(:one).id)
    # assert_equal test_case_template_param_0.seq, 1
#
    # test_case_template_param_1 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test2', test_case_templates(:one).id)
    # assert_equal test_case_template_param_1.seq, 0
#
    # post_test_case_id = TestCase.find_by_name(test_case_templates(:one).name.scan(/\w+/).join('_') + "_#{test_case_template_param_1.id}_#{test_case_template_param_0.id}").id
    # assert_equal pre_test_case_id, post_test_case_id
#
    # test_cases = test_case_template_param_1.test_case_template_param_instances.first.test_cases
    # assert_equal test_cases.size, 1
#
    # test_case = test_cases.first
    # assert_equal test_case.name, test_case_templates(:one).name.scan(/\w+/).join('_') + "_#{test_case_template_param_1.id}_#{test_case_template_param_0.id}"
  # end
#
  # # 1 param with 2 instances, 2 params
  # def test_move_up_2_2
    # params = create_params_with_2instances(2)
    # prev_test_case_names = test_case_templates(:one).test_case_template_params.collect {|param| param.test_case_template_param_instances.collect(&:name)}
    # pre_test_case_names = [test_case_templates(:one).test_case_name_prefix].product(*prev_test_case_names)
    # prev_test_case_ids = pre_test_case_names.collect {|item| TestCase.find_by_name(item.join('_')).id}
    # post_test_case_names = after_test_case_names(pre_test_case_names, 1, 2)
#
    # post :move_up, id: params[1].id
    # assert_response :redirect
#
    # params[0], params[1] = params[1], params[0]
    # assert_param_moved_correct(prev_test_case_ids, post_test_case_names, params, 2)
  # end
#
  # # 1 param with 2 instances, 3 params, move up middle param
  # def test_move_up_2_2_2_middle
    # params = create_params_with_2instances(3)
    # prev_test_case_names = test_case_templates(:one).test_case_template_params.collect {|param| param.test_case_template_param_instances.collect(&:name)}
    # pre_test_case_names = [test_case_templates(:one).test_case_name_prefix].product(*prev_test_case_names)
    # prev_test_case_ids = pre_test_case_names.collect {|item| TestCase.find_by_name(item.join('_')).id}
    # post_test_case_names = after_test_case_names(pre_test_case_names, 1, 2)
#
    # post :move_up, id: params[1].id
    # assert_response :redirect
#
    # params[0], params[1] = params[1], params[0]
#
    # assert_param_moved_correct(prev_test_case_ids, post_test_case_names, params, 4)
  # end
#
  # # 1 param with 2 instances, 3 params, move up last param
  # def test_move_up_2_2_2_last
    # params = create_params_with_2instances(3)
    # prev_test_case_names = test_case_templates(:one).test_case_template_params.collect {|param| param.test_case_template_param_instances.collect(&:name)}
    # pre_test_case_names = [test_case_templates(:one).test_case_name_prefix].product(*prev_test_case_names)
    # prev_test_case_ids = pre_test_case_names.collect {|item| TestCase.find_by_name(item.join('_')).id}
    # post_test_case_names = after_test_case_names(pre_test_case_names, 2, 3)
#
    # post :move_up, id: params[2].id
    # assert_response :redirect
#
    # params[1], params[2] = params[2], params[1]
#
    # assert_param_moved_correct(prev_test_case_ids, post_test_case_names, params, 4)
  # end
#
    # # 1 param with 1 instance, 2 params
  # def test_move_down_1_1
    # create(name: 'test1', test_case_template_id: test_case_templates(:one).id)
    # create(name: 'test2', test_case_template_id: test_case_templates(:one).id)
#
    # test_case_template_param_0 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test1', test_case_templates(:one).id)
    # test_case_template_param_1 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test2', test_case_templates(:one).id)
    # pre_test_case_id = TestCase.find_by_name(test_case_templates(:one).name.scan(/\w+/).join('_') + "_#{test_case_template_param_0.id}_#{test_case_template_param_1.id}").id
#
    # post :move_down, id: test_case_template_param_0.id
    # assert_response :redirect
#
    # test_case_template_param_0 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test2', test_case_templates(:one).id)
    # assert_equal test_case_template_param_0.seq, 0
#
    # test_case_template_param_1 = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test1', test_case_templates(:one).id)
    # assert_equal test_case_template_param_1.seq, 1
#
    # post_test_case_id = TestCase.find_by_name(test_case_templates(:one).name.scan(/\w+/).join('_') + "_#{test_case_template_param_0.id}_#{test_case_template_param_1.id}").id
    # assert_equal pre_test_case_id, post_test_case_id
#
    # test_cases = test_case_template_param_1.test_case_template_param_instances.first.test_cases
    # assert_equal test_cases.size, 1
#
    # test_case = test_cases.first
    # assert_equal test_case.name, test_case_templates(:one).name.scan(/\w+/).join('_') + "_#{test_case_template_param_0.id}_#{test_case_template_param_1.id}"
  # end
#
  # # 1 param with 2 instances, 2 params
  # def test_move_down_2_2
    # params = create_params_with_2instances(2)
    # prev_test_case_names = test_case_templates(:one).test_case_template_params.collect {|param| param.test_case_template_param_instances.collect(&:name)}
    # pre_test_case_names = [test_case_templates(:one).test_case_name_prefix].product(*prev_test_case_names)
    # prev_test_case_ids = pre_test_case_names.collect {|item| TestCase.find_by_name(item.join('_')).id}
    # post_test_case_names = after_test_case_names(pre_test_case_names, 1, 2)
#
    # post :move_down, id: params[0].id
    # assert_response :redirect
#
    # params[0], params[1] = params[1], params[0]
#
    # assert_param_moved_correct(prev_test_case_ids, post_test_case_names, params, 2)
  # end
#
  # # 1 param with 2 instances, 3 params, move down middle param
  # def test_move_down_2_2_2_middle
    # params = create_params_with_2instances(3)
    # prev_test_case_names = test_case_templates(:one).test_case_template_params.collect {|param| param.test_case_template_param_instances.collect(&:name)}
    # pre_test_case_names = [test_case_templates(:one).test_case_name_prefix].product(*prev_test_case_names)
    # prev_test_case_ids = pre_test_case_names.collect {|item| TestCase.find_by_name(item.join('_')).id}
    # post_test_case_names = after_test_case_names(pre_test_case_names, 2, 3)
#
    # post :move_down, id: params[1].id
    # assert_response :redirect
#
    # params[1], params[2] = params[2], params[1]
#
    # assert_param_moved_correct(prev_test_case_ids, post_test_case_names, params, 4)
  # end
#
  # # 1 param with 2 instances, 3 params, move down first param
  # def test_move_down_2_2_2_first
    # params = create_params_with_2instances(3)
    # prev_test_case_names = test_case_templates(:one).test_case_template_params.collect {|param| param.test_case_template_param_instances.collect(&:name)}
    # pre_test_case_names = [test_case_templates(:one).test_case_name_prefix].product(*prev_test_case_names)
    # prev_test_case_ids = pre_test_case_names.collect {|item| TestCase.find_by_name(item.join('_')).id}
    # post_test_case_names = after_test_case_names(pre_test_case_names, 1, 2)
#
    # post :move_down, id: params[0].id
    # assert_response :redirect
#
    # params[0], params[1] = params[1], params[0]
#
    # assert_param_moved_correct(prev_test_case_ids, post_test_case_names, params, 4)
  # end
#
  # def test_move_up_move_down
    # params = create_params_with_2instances(3)
#
    # post :move_up, id: params[1].id
    # assert_response :redirect
#
    # post :move_down, id: params[1].id
    # assert_response :redirect
#
    # assert_param_moved_correct(nil, nil, params, 4)
  # end
#
  # def test_move_down_move_up
    # params = create_params_with_2instances(3)
#
    # post :move_down, id: params[1].id
    # assert_response :redirect
#
    # post :move_up, id: params[1].id
    # assert_response :redirect
#
    # assert_param_moved_correct(nil, nil, params, 4)
  # end

  def test_update_param_name
    test_case_template_param_1 = create(name: 'test1', test_case_template_id: test_case_templates(:one).id)

    post :update, id: test_case_template_param_1.id, :test_case_template_param => {name: "test1_update" }

    test_case_template_param_1 = TestCaseTemplateParam.find(test_case_template_param_1.id)

    assert_equal test_case_template_param_1.name, "test1_update"
    assert_equal test_case_template_param_1.test_case_template_id, test_case_templates(:one).id
  end
#
  # def test_delete_should_not_delete_if_not_empty
    # test_case_template_param = create(name: 'test1', test_case_template_id: test_case_templates(:one).id)
#
    # delete(test_case_template_param)
#
    # test_case_template_param = TestCaseTemplateParam.find_by_name_and_test_case_template_id('test1', test_case_templates(:one).id)
#
    # assert_not_nil test_case_template_param
    # assert_equal 'test1', test_case_template_param.name
    # assert_equal "#{test_case_template_param.id}", test_case_template_param.test_case_template_param_instances.first.name
  # end
#
  # def test_delete_without_instances
    # test_case_template_param_1 = create(name: 'test1', test_case_template_id: test_case_templates(:one).id)
#
    # test_case_template_param_1.test_case_template_param_instances.each(&:destroy)
#
    # delete(test_case_template_param_1)
#
    # assert_nil TestCaseTemplateParam.find_by(name: 'test1', test_case_template_id: test_case_templates(:one).id)
    # assert_nil TestCaseTemplateParam.find_by(id: test_case_template_param_1.id)
  # end

  private
    def assert_test_case_template_param_created(name, test_case_template_id)
      test_case_template_param = TestCaseTemplateParam.find_by_name_and_test_case_template_id(name, test_case_template_id)
      assert_not_nil test_case_template_param

      yield test_case_template_param, nil if block_given?
    end

    def create_test_results(test_case)
      ActiveRecord::Base.connection.execute("INSERT INTO `test_results` (`test_case_id`, `test_target_instance_id`, `value`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES (#{test_case.id}, #{test_target_instances(:one).id}, 1, NOW(), NOW(), #{session[:member_id]}, #{session[:member_id]}), (#{test_case.id}, #{test_target_instances(:one).id}, 2, NOW(), NOW(), #{session[:member_id]}, #{session[:member_id]})")
      ActiveRecord::Base.connection.execute("INSERT INTO `weighted_test_results` (`test_case_id`, `test_target_instance_id`, `value`, `created_at`, `updated_at`) VALUES (#{test_case.id}, #{test_target_instances(:one).id}, 3, NOW(), NOW())")
      test_case = TestCase.find(test_case.id)
      [test_case.test_results, test_case.weighted_test_results]
    end

    def after_test_case_names(pre_test_case_names, step1, step2)
      after_case_names = []
      Marshal.load(Marshal.dump(pre_test_case_names)).each do |item|
        item[step1], item[step2] = item[step2], item[step1]
        after_case_names << item
      end
      after_case_names
    end

    def create_params_with_2instances(count)
      params = []
      1.upto(count) do |i|
        test_case_template_param = create(name: "test#{i}", test_case_template_id: test_case_templates(:one).id)
        TestCaseTemplateParamInstance.create_all(test_case_template_param, ["instance#{i}"])
        params << TestCaseTemplateParam.find_by_name_and_test_case_template_id("test#{i}", test_case_templates(:one).id)
      end
      params
    end

    def assert_param_moved_correct(prev_test_case_ids, post_test_case_names, test_case_template_params, test_cases_size)
      assert_equal prev_test_case_ids.sort, TestCase.where("test_target_id = ? and name in (?)", session[:test_target_id], post_test_case_names.map {|item| item.join('_')}).map(&:id).sort unless prev_test_case_ids.nil? || prev_test_case_ids.empty?

      test_case_template_params = test_case_template_params.map {|param| TestCaseTemplateParam.find_by(name: param.name, test_case_template_id: test_case_templates(:one).id)}
      assert_equal test_case_template_params.map(&:seq), (0...test_case_template_params.size).to_a

      test_case_names = TestCaseTemplate.find(test_case_templates(:one).id).test_case_names
      assert_equal test_case_names.size, TestCase.where("test_target_id = ? and name in (?)", session[:test_target_id], test_case_names).count
    end

    def create(params)
      post :create, new_test_case_template_param: params
      TestCaseTemplateParam.find_by(params)
    end

    def delete(test_case_template_param)
      post :delete, id: test_case_template_param.id
    end
end
