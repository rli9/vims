class TestTargetInstancesController < ProjectsController
  before_filter :validate_access_right?, :except => [:index, :list, :new, :create]
  before_action :set_test_target_instance, :only => [:show_test_report, :edit, :update, :delete, :delete_test_results_by_test_case_names]

  def index
    @test_target_instances = TestTargetInstance.where(test_target_id: session[:test_target_id]).sort {|x, y| y.change_list_id <=> x.change_list_id}
    @project = Project.find(session[:project_id])
  end

  def test_results
    @test_target_instance = TestTargetInstance.find(params[:id])
  end

  def new
    @test_target = TestTarget.new
  end

  def create
    @test_target_instance = TestTargetInstance.new(test_target_instance_params.merge(test_target_id: Project.find(session[:project_id]).test_target.id,
                                                                                     created_by: session[:member_id],
                                                                                     updated_by: session[:member_id]))

    if @test_target_instance.save
      flash[:notice] = "test target instance #{@test_target_instance.name} saved successfully !"
      redirect_to :action => 'index'
    else
      flash[:notice] = "fail to save test target instance !"
      render :action => "new"
    end
  end

  def test_target_instance_params
    params.require(:test_target_instance).permit(:name, :change_list_id)
  end

  def show
    @test_target_instance = TestTargetInstance.find(params[:id])
  end

  def edit_test_result_batch
    @test_target_instance = TestTargetInstance.find(params[:id])
  end

  def edit_test_result_by_test_suite
    @test_target_instance = TestTargetInstance.find(params[:id])
    @top_test_suites = @test_target_instance.test_target.top_test_suites
  end

  def create_test_results_by_test_case_names
    test_case_names = params[:test_case_names].lines.uniq

    value = params[:test_result][:value]

    @test_target_instance = params[:id].nil? ? TestTargetInstance.find_by_name(params[:test_target_instance_name]) : TestTargetInstance.find(params[:id])
    test_target_id = @test_target_instance.test_target_id

    @member = Member.find(session[:member_id])

    TestResult.transaction do
      test_case_names.every(5000) do |partial_test_case_names|
        test_cases = TestCase.where(:name => partial_test_case_names, test_target_id: test_target_id).select('id, name')

        unless test_cases.size == partial_test_case_names.size
          valid_test_case_names = test_cases.map(&:name).map(&:downcase)
          invalid_test_case_names = partial_test_case_names.reject {|name| valid_test_case_names.include?(name.downcase)}
          test_cases += TestCase.create(invalid_test_case_names.map {|test_case_name| {name: test_case_name, test_target_id: test_target_id}})
        end

        test_case_ids = test_cases.map(&:id)

        TestResult.create_all(test_case_ids, @test_target_instance, value, @member.id)

        weighted_test_results = WeightedTestResult.in_test_target_instance(test_case_ids, @test_target_instance).select('value, test_case_id')
        unless weighted_test_results.empty?
          changed_test_case_ids = weighted_test_results.reject {|test_result| test_result.value == value}.map(&:test_case_id)
        end

        non_existing_test_case_ids = test_case_ids - weighted_test_results.map(&:test_case_id)
        WeightedTestResult.transaction do
          create_or_update_weighted_test_results(value, changed_test_case_ids, non_existing_test_case_ids)
        end
      end
    end

    render :action => 'edit_test_result_batch', :id => @test_target_instance.id
  end

  def create_or_update_weighted_test_results(value, changed_test_case_ids, non_existing_test_case_ids, test_target_instance_id = 0)
    @test_target_instance = TestTargetInstance.find(test_target_instance_id.to_i) if @test_target_instance.nil?
    if changed_test_case_ids
      test_results_hash = changed_test_case_ids.collect_every(5000) {|slice| TestResult.where(WeightedTestResult.where_condition(slice, @test_target_instance)).select('test_case_id, value')}.group_by(&:test_case_id)

      test_case_ids = test_results_hash.select {|key, _value| _value.size == 1}.keys
      test_case_ids.every(5000) {|slice| WeightedTestResult.in_test_target_instance(slice, @test_target_instance).update_all(:value => value, :updated_at => Time.now)} if test_case_ids.size > 0

      unless test_results_hash.size == test_case_ids.size
        test_results_hash = test_results_hash.select {|key, _value| _value.size != 1}
        test_case_ids = test_results_hash.keys

        test_case_ids.every(5000) do |slice|
          #TODO combine weighted_test_result who has same weighted_test_result.value to use update_all
          WeightedTestResult.in_test_target_instance(slice, @test_target_instance).each do |weighted_test_result|
            weighted_test_result.save_on_value_change(test_results_hash[weighted_test_result.test_case_id].inject(0) {|acc, test_result| acc | test_result.value})
          end
        end
      end
    end

    # Case 1: no TR, yes WTR
    if non_existing_test_case_ids
      weighted_test_results = non_existing_test_case_ids.collect_every(5000) {|slice| WeightedTestResult.in_test_target_instance(slice, @test_target_instance)}

      #TODO combine weighted_test_result who has same weighted_test_result.value to use update_all
      weighted_test_results.each {|weighted_test_result| weighted_test_result.save_on_value_change(weighted_test_result.value | value)}

      # Case 2: no TR, no WTR
      unless non_existing_test_case_ids.size == weighted_test_results.size
        (non_existing_test_case_ids - weighted_test_results.map(&:test_case_id)).every(5000) do |partial_test_case_ids|
          WeightedTestResult.create(partial_test_case_ids.map {|test_case_id| {test_case_id: test_case_id, test_target_instance_id: @test_target_instance.id, value: value}})
        end
      end
    end
  end

  def delete
    #FIXME add test_target_instance deletable? check
    if @test_target_instance.destroy
      flash[:notice] = "Delete #{@test_target_instance.name} successfully"
    else
      flash[:error] = "Fail to destroy #{@test_target_instance.name}"
    end

    redirect_to :controller => 'test_target_instances', :action => 'index'
  end

  def delete_test_results_by_test_case_names
    test_case_names = params[:test_case_names].lines.uniq
    @test_cases = TestCase.where("test_target_id = ? and name in (?)", session[:test_target_id], test_case_names)

    impacted_test_case_ids = TestResult.transaction do
      @test_cases.map(&:id).collect_every(5000) do |partial_test_case_ids|
        impacted_test_case_ids = TestResult.where(test_target_instance_id: @test_target_instance.id, created_by: session[:member_id], test_case_id: partial_test_case_ids.join(','))
                                           .select(:test_case_id)
                                           .map {|test_result| test_result.test_case_id}

        TestResult.delete_all("test_target_instance_id = #{@test_target_instance.id} and created_by = #{session[:member_id]} and test_case_id in (#{partial_test_case_ids.join(',')})")
        rest_weighted_test_target_instance_results = TestResult.where(test_target_instance_id: @test_target_instance.id, test_case_id: partial_test_case_ids.join(','))
                                                               .select(:test_case_id)
        check_nil_and_update_weighted_test_results(rest_weighted_test_target_instance_results, partial_test_case_ids, WeightedTestResult, @test_target_instance)

        impacted_test_case_ids
      end
    end

    @unimpacted_test_case_names = []
    unless impacted_test_case_ids.size == test_case_names.size
      impacted_test_case_names = @test_cases.select {|test_case| impacted_test_case_ids.include?(test_case.id)}.map(&:name).map(&:downcase)
      @unimpacted_test_case_names = test_case_names.map(&:downcase) - impacted_test_case_names
    end

    if @unimpacted_test_case_names.empty?
      flash[:notice] = "Successfully delete #{test_case_names.size} test results"
      redirect_to :action => 'edit_test_result_batch', :id => params[:id]
    else
      flash[:notice] = "#{@unimpacted_test_case_names.size} test cases are not found (either wrong test case name or no test results associated)"
      render :action => 'edit_test_result_batch', :id => params[:id]
    end
  end

  def check_nil_and_update_weighted_test_results(test_results, test_case_ids, db_table, test_target_instance)
    rest_test_case_ids = test_results.map(&:test_case_id).uniq

    if rest_test_case_ids.size < test_case_ids.size
      nil_test_target_instance_results_test_case_ids = test_case_ids - rest_test_case_ids
      db_table.in_test_target_instance(nil_test_target_instance_results_test_case_ids, test_target_instance).delete_all
    end

    update_weighted_test_target_test_results_by_case_id(rest_test_case_ids, test_target_instance, db_table) unless rest_test_case_ids.empty?
  end

  def update_weighted_test_target_test_results_by_case_id(collection, test_target_instance, db_table)
    final_weighted_test_results = db_table.where(["test_case_id in (#{collection.join(',')}) and test_target_instance_id = #{test_target_instance.id}"])
    rest_test_target_instance_test_results_hash = collection.collect_every(5000) {|slice| TestResult.where(db_table.where_condition(slice, test_target_instance)).select('test_case_id, value')}.group_by(&:test_case_id)
    final_test_case_ids_weighted_test_results = Hash.new
    final_weighted_test_results.each do |item|
      new_value = rest_test_target_instance_test_results_hash[item.test_case_id].inject {|weighted_result, result| weighted_result.value | result.value}
      final_test_case_ids_weighted_test_results[item.id] = {"value" => new_value} unless new_value == item.value
    end
    db_table.update(final_test_case_ids_weighted_test_results.keys, final_test_case_ids_weighted_test_results.values)
  end

  def show_test_report
    @weighted_test_results = @test_target_instance.weighted_test_results.select('test_case_id, value')

    @bug_tracker_url = TestTarget.find(session[:test_target_id]).bug_tracker_url
    @test_case_ids_bug_tracks = BugTrack.where(test_target_id: session[:test_target_id]).includes(:bug).group_by(&:test_case_id)

    @test_case_ids = @weighted_test_results.map(&:test_case_id)
    test_cases = @test_case_ids.collect_every(10000) do |partial_test_case_ids|
      TestCase.where(id: partial_test_case_ids).select('id, name')
    end

    test_case_ids_test_cases = Hash[test_cases.map {|test_case| [test_case.id, test_case]}]

    @compare_test_target_instance = TestTargetInstance.find_by(id: params[:compared_test_target_instance_id])
    compare_test_target_instances = [@compare_test_target_instance || @test_target_instance.previous_test_target_instances.first(5)].flatten

    prepare_history_test_report(compare_test_target_instances, @test_case_ids, test_case_ids_test_cases)
    prepare_template_test_report(test_case_ids_test_cases)
  end

  def prepare_history_test_report(test_target_instances, test_case_ids, test_case_ids_test_cases)
    @history_report = {}
    [TestResult::TEST_TARGET_FIX, TestResult::TEST_TARGET_REGRESSION, TestResult::TEST_TARGET_KEEP_PASS, TestResult::TEST_TARGET_KEEP_FAIL,
     TestResult::TEST_TARGET_NEW_FAIL, TestResult::TEST_TARGET_NEW_PASS,
     TestResult::TEST_CASE_FAIL].each {|key| @history_report[key] = []}

    test_case_ids_weighted_test_results = {}
    @weighted_test_results.each do |weighted_test_result|
      weighted_test_result.value = weighted_test_result.deduced_value
      test_case_ids_weighted_test_results[weighted_test_result.test_case_id] = weighted_test_result
    end

    test_target_instances.each do |test_target_instance|
      reported_test_case_ids = test_case_ids.collect_every(10000) do |collection|
        prev_weighted_test_results = WeightedTestResult.where(test_case_id: collection, test_target_instance_id: test_target_instance.id)

        prev_weighted_test_results.each do |prev_weighted_test_result|
          prev_weighted_test_result.value = prev_weighted_test_result.deduced_value
          curr_weighted_test_result = test_case_ids_weighted_test_results[prev_weighted_test_result.test_case_id]

          @history_report[curr_weighted_test_result.test_status(prev_weighted_test_result)] << [test_target_instance, test_case_ids_test_cases[prev_weighted_test_result.test_case_id]]
        end

        prev_weighted_test_results.map(&:test_case_id)
      end

      test_case_ids -= reported_test_case_ids
    end

    # Deal w/ remained test_case_ids
    test_case_ids.each do |remained_test_case_id|
      curr_weighted_test_result = test_case_ids_weighted_test_results[remained_test_case_id]
      @history_report[curr_weighted_test_result.test_status] << [nil, test_case_ids_test_cases[remained_test_case_id]]
    end
  end

  def prepare_template_test_report(test_case_ids_test_cases)
    template_report = {}
    @history_report.each do |status, value|
      value.each {|test_target_instance, test_case| template_report[test_case.name.downcase] = [test_case, status]}
    end

    @test_case_templates_test_result_stats = {}
    @test_case_templates_test_case_names = {}

    @test_target_instance.test_target.test_case_templates.includes(:test_case_template_params).each do |test_case_template|
      regexp = test_case_template.regexp

      matches = []
      test_cases = test_case_ids_test_cases.values.select do |test_case|
        m = regexp.expression.match(test_case.name)
        matches << m if m
        m
      end

      next if matches.empty?

      test_case_ids = test_cases.map(&:id)

      test_result_stats = @test_case_templates_test_result_stats[test_case_template] = Hash[@history_report.map {|status, items| [status, items.count {|item| test_case_ids.include?(item[1].id)}]}]
      next if test_result_stats[TestResult::TEST_TARGET_KEEP_FAIL] + test_result_stats[TestResult::TEST_TARGET_FIX] + test_result_stats[TestResult::TEST_TARGET_REGRESSION] + test_result_stats[TestResult::TEST_TARGET_NEW_FAIL] == 0

      test_case_template_param_matcheses = regexp.keys.map {|key| matches.map {|m| m[key]}.uniq {|item| item.downcase}.sort_by {|item| item.downcase}}
      first_test_case_template_param_matches = test_case_template_param_matcheses.first

      test_case_names_matrix = test_case_template.test_case_names_matrix(test_case_template_param_matcheses)

      test_cases_test_results_matrix = test_case_names_matrix.map do |test_case_names|
        test_case_names.map(&:downcase).map {|test_case_name| template_report[test_case_name] || [nil, TestResult::TEST_TARGET_NOT_RUN]}
      end

      undisplayable_rows = test_cases_test_results_matrix.map {|items| items.all? {|item| item[1] == TestResult::TEST_TARGET_NOT_RUN || item[1] == TestResult::TEST_TARGET_KEEP_PASS || item[1] == TestResult::TEST_TARGET_NEW_PASS}}
                                                         .reverse

      undisplayable_rows.each_index do |index|
        if undisplayable_rows[index]
          row = undisplayable_rows.size - 1 - index

          test_cases_test_results_matrix.delete_at(row)
          first_test_case_template_param_matches.delete_at(row)
        end
      end

      test_cases_test_results_matrix = test_cases_test_results_matrix.transpose
      displayable_cols = test_cases_test_results_matrix.map {|items| items.any? {|item| item[1] != TestResult::TEST_TARGET_NOT_RUN}}
                                                       .reverse

      displayable_cols.each_index {|index| test_cases_test_results_matrix.delete_at(displayable_cols.size - 1 - index) unless displayable_cols[index]}
      test_cases_test_results_matrix = test_cases_test_results_matrix.transpose

      next if test_cases_test_results_matrix.empty?

      @test_case_templates_test_case_names[test_case_template] = Struct.new(:test_cases_test_results_matrix, :first_test_case_template_param_matches, :displayable_cols, :test_case_template_param_matcheses)
                                                                       .new(test_cases_test_results_matrix, first_test_case_template_param_matches, displayable_cols.reverse, test_case_template_param_matcheses)
    end
  end

  def edit
  end

  def update
    params.permit!
    if @test_target_instance.update(params[:test_target_instance])
      flash[:notice] = "Edit Build Successful"
      redirect_to :action => 'index'
    else
      render :action => "edit"
    end
  end

  protected
    def create_test_target_instance(name)
      test_target_instance = TestTargetInstance.new(:name => name, :change_list_id => Time.now.strftime('%Y%m%d').delete(" ").to_i)
      test_target_instance.test_target_id = Project.find(session[:project_id]).test_target.id
      test_target_instance.created_by = session[:member_id]
      test_target_instance.updated_by = session[:member_id]
      if test_target_instance.save
        test_target_instance
      else
        nil
      end
    end

    def validate_access_right?
      if params[:id].nil?
        test_target_instance = TestTargetInstance.find_by_name(params[:test_target_instance_name])
        test_target_instance = create_test_target_instance(params[:test_target_instance_name]) if test_target_instance.nil?
      else
        test_target_instance = TestTargetInstance.find(params[:id])
      end

      if test_target_instance.nil? || @project.test_target != test_target_instance.test_target
        render :partial => 'shared/error_url'
        return false
      else
        return true
      end
    end

    def set_test_target_instance
      @test_target_instance = TestTargetInstance.find(params[:id])
    end
end
