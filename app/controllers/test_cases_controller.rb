class TestCasesController < ProjectsController
  before_filter :validate_test_case_access_right?, :except => [:list, :search, :new, :create,
                                      :cut, :paste]

  def list
    if params[:test_suite_id]
      session[:test_suite_id] = params[:test_suite_id]
      @test_suite = @project.test_target.test_suites.find(params[:test_suite_id])
      @test_cases = @test_suite.test_cases.find(
                           :all,
                           :select => "test_cases.id, name")
      @order_by_asc_desc = "asc"
      if params[:order_by]
        @order_by_field = params[:order_by][:field]
        @order_by_asc_desc = params[:order_by][:asc_desc]
        sort_by_filed_and_order(@test_cases, @order_by_field, @order_by_asc_desc)
      end
    elsif params[:test_case_ids]
      #FIXME check integrity of test_case_ids, belongs to test target or not
      test_case_ids = params[:test_case_ids].split(/\D/)
      @test_cases = TestCase.find(test_case_ids)
    elsif params[:work_year] && params[:work_week]
      work_year = params[:work_year].to_i
      work_week = params[:work_week].to_i

      @test_cases = @project.test_target.test_cases.select do |test_case|
        test_case.created_at && test_case.created_at.work_year == work_year &&
        test_case.created_at.work_week == work_week
      end
    else
      @test_cases = []
    end
  end

  def sort_by_filed_and_order(result_sets, order_by_field, order_by_asc_desc)
    if order_by_asc_desc == "desc"
      @test_cases = result_sets.sort {|a, b| b.send(order_by_field) <=> a.send(order_by_field)}
      @order_by_asc_desc = "asc"
    elsif order_by_asc_desc == "asc"
      @test_cases = result_sets.sort {|a, b| a.send(order_by_field) <=> b.send(order_by_field)}
      @order_by_asc_desc = "desc"
    end
  end

  def search
    @key_word = params[:key_word] && params[:key_word].strip

    if @key_word && @key_word.size > 5
      key_word = Regexp.escape(@key_word).downcase
      @test_cases = TestCase.where("test_target_id = ? AND name like ?", session[:test_target_id], "%" + key_word + "%")
    end

    render :action => 'search'
  end

  def delete
    test_case = TestCase.find(params[:id])
    @test_suite_id = test_case.find_test_suite_of_test_case.id
    if test_case && test_case.deletable?
      test_case.test_suite_ids.each do |test_suite_id|
        expire_fragment(Regexp.new("list\.member_id=[0-9]+&test_suite_id=#{test_suite_id}.cache"))
      end

      flash[:notice] = "Delete #{test_case.name}, Version #{test_case.version} success" if test_case.destroy
    else
      flash[:notice] = "Can't delete #{test_case.name}, it's not lastest version of this case"
    end

    redirect_to :controller => 'test_suites', :action => 'folder_list', :id => 0, :test_suite_id => @test_suite_id
  end

  def delete_force
    test_case = TestCase.find(params[:id])
    if test_case
      test_case.destroy

      flash[:notice] = "Delete #{test_case.name}, Version #{test_case.version} success" if test_case.destroy
    else
      flash[:notice] = "Can't find #{test_case.name}"
    end

    redirect_to :controller => 'test_case_templates', :action => 'index'
  end

  def del_case_ajax
    test_case = TestCase.find(params[:id])
    if test_case
      @current_test_suite = test_case.find_test_suite_of_test_case
      @test_suites = @current_test_suite.child_test_suites
      @test_cases = @current_test_suite.latest_version_active_test_cases
    end

    if test_case && test_case.deletable?
      test_case.test_suite_ids.each do |test_suite_id|
        expire_fragment(Regexp.new("list\.member_id=[0-9]+&test_suite_id=#{test_suite_id}.cache"))
      end

      flash[:notice] = "Delete #{test_case.name}, Version #{test_case.version} success" if test_case.destroy
    else
      flash[:notice] = "Can't delete #{test_case.name}, it's not lastest version of this case"
    end

    respond_to do |format|
      format.html {redirect_to :controller => "test_suites", :action => "folder_list", :id => 0, :test_suite_id => @current_test_suite.id }
      format.js
    end
  end

  # GET /test_cases/new
  # GET /test_cases/new.xml
  def new
    @top_test_suites = @project.test_target.top_test_suites
    if params[:test_suite_id]
      @select_test_suite = TestSuite.find(params[:test_suite_id])
    end
    @test_case = TestCase.new
  end

  def show
    @test_case = TestCase.find(params[:id])
    #@top_test_suites = @project.test_target.top_test_suites
  end

  # GET /test_cases/1/edit
  def edit
    @test_case = TestCase.find(params[:id])
    @top_test_suites = @project.test_target.top_test_suites
  end

  def paste
    @test_case_ids = session[:cut_case_ids]
    @test_cases = TestCase.find(@test_case_ids)
    @paste_destination_suite = TestSuite.find(params[:id])

    @test_cases.each do |test_case|
      test_case.test_suites << @paste_destination_suite
    end

    session[:cut_case_ids] = nil
    redirect_to :controller => "test_suites", :action => "folder_list", :id => 0, :test_suite_id => @paste_destination_suite.id
  end

  def cut
    session[:cut_case_ids] = params[:test_case_ids]
    redirect_to :controller => "test_suites", :action => "folder_list", :id => 0, :test_suite_id => params[:test_suite_id]
  end

  # POST /test_cases
  # POST /test_cases.xml
  def create
    @top_test_suites = @project.test_target.top_test_suites
    transaction_flag = false

    begin
      TestCase.transaction do
        @test_case = TestCase.new(params[:test_case])
        @test_case.created_by = session[:member_id]

        raise ActiveRecord::Rollback unless @test_case.save

        test_suite_ids = params[:test_suite_ids]
        if test_suite_ids.nil?
          @test_case.errors.add_to_base("Please select one test suite at least")
          raise ActiveRecord::Rollback
        end

        @test_case.test_suites = TestSuite.find(test_suite_ids)

        transaction_flag = true
      end
    rescue
      flash[:notice] = "Create Case Fail"
    end

    if transaction_flag
      @test_case.test_suite_ids.each do |test_suite_id|
        expire_fragment(Regexp.new("list\.member_id=[0-9]+&test_suite_id=#{test_suite_id}.cache"))
      end

      render :action => "show"
    else
      render :action => "new_" + @test_case[:type].underscore
    end
  end

  def update
    test_case = TestCase.find(params[:id]).last_test_case
    @test_case = test_case[:type].constantize.new(params[:test_case])
    transaction_flag = false

    TestCase.transaction do
      if version_update
        @test_case.created_by = session[:member_id]
        @test_case.test_target = test_case.test_target
        raise ActiveRecord::Rollback unless @test_case.save

        test_case.next_test_case_id = @test_case.id
        raise ActiveRecord::Rollback unless test_case.save
      else
        @test_case = test_case
        raise ActiveRecord::Rollback unless @test_case.update(params[:test_case])
      end

      transaction_flag = true
    end

    if transaction_flag
      suite_ids = test_case.test_suite_ids

      flash[:notice] = "Test case '#{test_case.name}' was successfully updated."
    else
      flash[:notice] = "Test case '#{test_case.name}' update fail."
    end
    @top_test_suites = @project.test_target.top_test_suites
    redirect_to :action => "edit", :id => @test_case.id
  end

  def new_test_result
    @test_case = TestCase.find(params[:id])
    @test_result = TestResult.empty_new
    @test_target_instances = @project.test_target.test_target_instances
  end

  def create_test_result
    @test_case = TestCase.find(params[:id])
    @test_result = TestResult.new(params[:test_result])
    @test_target_instances = @project.test_target.test_target_instances

    @test_result.test_case = @test_case
    @test_result.created_by = session[:member_id]
    if @test_result.save
      flash[:notice] = 'Done!'
      render :action => 'new_test_result'
    else
      render :action => 'new_test_result'
    end
  end

  protected
  def validate_test_case_access_right?
    test_case = TestCase.find(params[:id])

    if test_case.nil? || @project.test_target != test_case.test_target
      render :partial => 'shared/error_url'
      return false
    else
      return true
    end
  end

end
