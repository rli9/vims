class TestResultsController < ProjectsController
  # GET /test_cases
  # GET /test_cases.xml
  def index
    @test_target_instances = @project.test_target.test_target_instances
  end

  def history_test_result
    test_result = TestResult.find(params[:id])
    redirect_to :controller => :test_cases, :action => :history, :id => test_result.test_case_id
  end

  def list
    @test_target_instance = TestTargetInstance.find(params[:test_target_instance_id])
    @test_results = @test_target_instance.weighted_test_results
  end

  def edit_test_result
    @test_result = TestResult.find(params[:id])
  end

  def delete_test_result
    delete_object('test_result') {|object| validate_project_integrity?(object.test_target_instance.test_target)}
  end

  def update_test_result
    update_object('test_result') {|object| validate_project_integrity?(object.test_target_instance.test_target)}
  end

  def update_test_result2
    @test_result = TestResult.find(params[:id])
    if @test_result.update(params[:test_result])
      flash[:notice] = 'Done'
      render :action => 'edit_test_result'
    else
      render :action => 'edit_test_result'
    end
  end

  def edit
    @test_target_instance = TestTargetInstance.find(params[:test_target_instance_id])
    validate_project_integrity?(@test_target_instance.test_target)
    @test_suites = @project.test_target.test_suites
  end

  def create_test_result_internal(test_case, test_target_instance, test_target_pass, test_target_fail, test_case_fail)
    test_result = TestResult.new(:test_target_pass => test_target_pass, :test_target_fail => test_target_fail,
                                 :test_case_fail => test_case_fail,
                                 :test_case => test_case, :test_target_instance => test_target_instance)
    test_result.save
  end

  def update
    @test_target_instance = TestTargetInstance.find(params[:test_target_instance_id])
    validate_project_integrity?(@test_target_instance.test_target)
    @test_suites = @project.test_target.test_suites

    case params[:edit_type]
    when "add test results"
      @test_case_names = params[:test_case_names]
      default_test_target_pass = params[:default_test_target_pass].to_i
      default_test_target_fail = params[:default_test_target_fail].to_i
      default_test_case_fail = params[:default_test_case_fail].to_i

      added_test_cases = 0

      test_case_names = @test_case_names.lines
      test_case_names.each do |test_case_name|
        test_case = TestCase.find_by_test_target_id_and_name(session[:test_target_id], test_case_name)
        next if test_case.nil?
        added_test_cases += 1 if TestResult.create?(test_case, @test_target_instance, default_test_target_pass, default_test_target_fail,
                           default_test_case_fail)
      end

      flash[:notice] = "total #{test_case_names.nil? ? 0 : test_case_names.size} test cases, added #{added_test_cases}"

      redirect_to :action => 'edit', :id => 0, :test_target_instance_id => params[:test_target_instance_id]
    when "add test results by test suite"
      @test_suite = TestSuite.find(params[:test_suite][:id])

      default_test_target_pass = params[:default_test_target_pass].to_i
      default_test_target_fail = params[:default_test_target_fail].to_i
      default_test_case_fail = params[:default_test_case_fail].to_i


      test_cases = @test_suite.test_cases if @test_suite

      test_cases && test_cases.each do |test_case|
        TestResult.create?(test_case, @test_target_instance, nil, default_test_target_pass, default_test_target_fail,
                           default_test_case_fail, nil)
      end

      flash[:notice] = "total #{test_cases.nil? ? 0 : test_cases.size} test cases"

      redirect_to :action => 'edit', :id => 0, :test_target_instance_id => params[:test_target_instance_id]
    else
      redirect_to :action => "edit", :id => 0, :test_target_instance_id => params[:test_target_instance_id]
    end
  end

  def test_suite_report(test_suites, test_result_report)
    @top_test_suites = TestSuite.top_test_suites(test_suites)

    @test_suite_report = {}

    TestReport.types.each do |type|
      @test_suite_report[type] = {}

      test_result_report[type].each do |test_data_comparison|
        test_result = test_data_comparison.right
        test_result.test_case.top_test_suites.each do |root_test_suite|
          @test_suite_report[type]["#{root_test_suite.id}"] = @test_suite_report[type]["#{root_test_suite.id}"] || []
          @test_suite_report[type]["#{root_test_suite.id}"] << test_result
        end
      end
    end
  end

  def indicator
    @test_target_instance = TestTargetInstance.find(params[:test_target_instance_id])
    @weighted_test_results = @test_target_instance.weighted_test_results
    @latest_weighted_test_results = @project.test_target.latest_weighted_test_results_until(@test_target_instance)
    @test_suites = @project.test_target.top_test_suites.collect {|item| item.name.upcase}.
                           delete_if {|test_suite| test_suite.match(/BAT/) || test_suite.match(/CUSTOMER/) || test_suite.match(/WHQL/) || test_suite.match(/OEM/) || test_suite.match(/TRASH/) || test_suite.match(/PERFORMANCE/) || test_suite.match(/OTHER/) || test_suite.match(/BLOCK/)}.sort
  end

  def report
    t1 = Time.new

    @test_target_instance = TestTargetInstance.find(params[:test_target_instance_id])

    @weighted_test_results = @test_target_instance.weighted_test_results
    weighted_test_results_before = @test_target_instance.weighted_test_results_before
    @test_result_report = TestReport.report(@weighted_test_results, weighted_test_results_before, "test_case")

    flash[:notice] = (Time.new - t1).to_s

    render :partial => 'test_reports/show', :layout => true
  end
end
