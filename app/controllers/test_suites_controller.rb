class TestSuitesController < ProjectsController
  before_filter :validate_test_suite_access_right?, :except => [:index, :new, :create, :folder, :folder_list, :search]

  #caches_action :index, :cache_path => Proc.new {|c| {:member_id => c.request.session[:member_id], :project_id => c.request.session[:project_id]}}
  #cache_sweeper :test_suite_sweeper, :only => [:create, :update, :delete]

  def index
    @top_test_suites = @project.test_target.top_test_suites.sort {|x, y| x.name <=> y.name}
    @max_recursive_child_test_suite_depth = @top_test_suites.collect(&:max_recursive_child_test_suite_depth).max || 0
  end

  def folder
    @top_test_suites = @project.test_target.top_test_suites.sort {|x, y| x.name <=> y.name}

    @test_suite = TestSuite.new
    @test_suite.test_target = @project.test_target
    @select_test_suite_id = params[:test_suite_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml {render :xml => @test_suite }
    end

  end

  def search
    @key_words = params[:key_words] && params[:key_words].strip

    @test_cases = []
    if @key_words && !@key_words.empty?
      key_words = Regexp.escape(@key_words).downcase
      @test_cases = TestCase.where(["test_target_id = ? AND name like ?", session[:test_target_id], "%" + key_words + "%"])
    end

    render :template => 'test_suites/folder'
  end

  def folder_list
    if params[:test_suite_id]
      @current_test_suite = @project.test_target.test_suites.find(params[:test_suite_id])
      @test_suites = @current_test_suite.child_test_suites.sort {|x, y| x.name <=> y.name}
      @test_cases = @current_test_suite.latest_version_active_test_cases

      if params[:order_by]
        if params[:order_by][:direction]
          @order_by_for_back = params[:order_by][:direction]
        end
        if params[:order_by][:sort]
          @order_by_asc_desc = params[:order_by][:sort]
        end
      else
        @order_by_asc_desc = "asc"
        @order_by_for_back = "forward"
      end
      sort_by_direction_and_order(@test_cases, @order_by_for_back, @order_by_asc_desc)
    else
      @test_suites = TestSuite.where(test_target_id: session[:test_target_id])
      @test_suites = @test_suites.select {|test_suite| test_suite.parent_test_suites.empty?}.sort {|x, y| x.name <=> y.name}
    end

    @test_suite = TestSuite.new
    @test_suite.test_target = @project.test_target
    @select_test_suite_id = params[:test_suite_id]
  end

  def sort_by_direction_and_order(result_sets, order_by_direction, order_by_asc_desc)
    if order_by_direction == "forward"
      if order_by_asc_desc == "desc"
        @test_cases = result_sets.sort {|x, y| y.name <=> x.name}
        @order_by_asc_desc = "asc"
        @old_order_by_asc_desc = "desc"
      elsif order_by_asc_desc == "asc"
        @test_cases = result_sets.sort {|x, y| x.name <=> y.name}
        @order_by_asc_desc = "desc"
        @old_order_by_asc_desc = "asc"
      end
      @order_by_for_back = "backward"
      @old_order_by_for_back = "forward"
    elsif order_by_direction == "backward"
      if order_by_asc_desc == "desc"
        @test_cases = result_sets.sort {|x, y| y.name.reverse <=> x.name.reverse}
        @order_by_asc_desc = "asc"
        @old_order_by_asc_desc = "desc"
      elsif order_by_asc_desc == "asc"
        @test_cases = result_sets.sort {|x, y| x.name.reverse <=> y.name.reverse}
        @order_by_asc_desc = "desc"
        @old_order_by_asc_desc = "asc"
      end
      @order_by_for_back = "forward"
      @old_order_by_for_back = "backward"
    end
  end

  def new
    @test_suite = TestSuite.new
    @test_suite.test_target = @project.test_target
    @select_test_suite_id = params[:test_suite_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml {render :xml => @test_suite }
    end
  end

  def delete
    @test_suite = TestSuite.find(params[:id])
    @test_suite.destroy
    expire_fragment(Regexp.new("folder_list\.member_id=[0-9]+&project_id=#{session[:project_id]}+&test_suite_id=#{params[:id]}\.cache"))

    respond_to do |format|
      format.html {redirect_to :action => 'folder_list', :id => '0'}
      format.xml {head :ok }
      format.js {render :text => ""}
    end
  end

  # GET /test_suites/1/edit
  def edit
    @test_suite = TestSuite.find(params[:id])
    @parent_test_suites = @test_suite.parent_test_suites
    @parent_suite_ids = []
    if @parent_test_suites
      @parent_test_suites.each do |parent_test_suite|
        @parent_suite_ids << parent_test_suite.id
      end
    end
  end

  # POST /test_suites
  # POST /test_suites.xml
  def create
    params.permit!
    @test_suite = TestSuite.new(params[:test_suite])
    @test_suite.test_target_id = params[:test_target_id]
    parent_test_suite_ids = params[:parent_test_suite_ids] || []
    test_suites = TestSuite.where("test_target_id = ?", params[:test_target_id])
    transaction_flag = false
    ts_flag = 0
    begin
      TestSuite.transaction do
        raise ActiveRecord::Rollback unless @test_suite.save
        transaction_flag = true
        parent_test_suite_ids.uniq.each do |parent_test_suite_id|
          transaction_flag = false
          test_suites.each do |test_suite|
            if (test_suite.child_test_suite_of?(TestSuite.find(parent_test_suite_id))) && (test_suite.name == params[:test_suite][:name])
              ts_flag = ts_flag + 1
            end
          end
          if ts_flag == 0
            TestSuitesTestSuites.create(:parent_test_suite => TestSuite.find(parent_test_suite_id),
                                               :child_test_suite => @test_suite)
            transaction_flag = true
          else
            flash[:notice] = "The suite name has already in same suite"
            raise ActiveRecord::Rollback
          end
        end
      end
    rescue
      flash[:notice] = "Create Test Suite Fail"
    end

    if transaction_flag
      redirect_to :action => 'folder_list', :id => '0'
    else
      render :action => 'new'
    end
  end

  # PUT /test_suites/1
  # PUT /test_suites/1.xml
  def update
    @test_suite = TestSuite.find(params[:id])
    parent_test_suite_ids = params[:parent_test_suite_ids] || []
    transaction_flag = false
    begin
      TestSuite.transaction do
        raise ActiveRecord::Rollback unless @test_suite.update(params[:test_suite])
        parent_test_suites = TestSuite.find(parent_test_suite_ids.uniq)
        parent_test_suites = parent_test_suites.concat(parent_test_suites.collect(&:recursive_parent_test_suites).flatten).uniq
        parent_test_suites.each do |parent_test_suite|
          unless @test_suite.parent_test_suites.include?(parent_test_suite)
            parent_test_suite.test_cases << @test_suite.test_cases
          end
        end

        @test_suite.test_target.test_suites.each do |test_suite|
          assoc = TestSuitesTestSuites.find_by_parent_test_suite_id_and_child_test_suite_id(test_suite.id, @test_suite.id)
          if parent_test_suites.include?(test_suite)
            TestSuitesTestSuites.create(:parent_test_suite => test_suite, :child_test_suite => @test_suite) if assoc.nil?
          else
            assoc.destroy if assoc
          end
        end
        transaction_flag = true
      end
    rescue
      flash[:notice] = "Update Test Suite Fail"
    end
    if transaction_flag
      flash[:notice] = "Test Suite '#{@test_suite.name}' was successfully updated."
      redirect_to :action => 'folder_list', :id => '0'
    else
      render :action => 'edit'
    end
  end

  def new_test_case_test_suite_association
    @test_suite = TestSuite.find(params[:id])
    @test_case_test_suite_association = TestCaseTestSuiteAssociation.new
  end

  def create_test_case_test_suite_association
    @test_suite = TestSuite.find(params[:id])
    @test_case_name = params[:test_case_name]
    @test_case = TestCase.find_by_test_target_id_and_name(@test_suite.test_target_id, @test_case_name)

    test_suites = @test_suite.recursive_parent_test_suites
    test_suites << @test_suite

    @test_case.test_suites = test_suites

    flash[:notice] = "#{@test_case.name} is successfully added in #{@test_suite.name}"
    redirect_to :action => "new_test_case_test_suite_association", :id => @test_suite
  end

protected
  def validate_test_suite_access_right?
    test_suite = TestSuite.find(params[:id])

    if test_suite.nil? || @project.test_target != test_suite.test_target
      render :partial => 'shared/error_url'
      return false
    else
      return true
    end
  end
end
