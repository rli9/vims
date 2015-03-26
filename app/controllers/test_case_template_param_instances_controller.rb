class TestCaseTemplateParamInstancesController < ProjectsController
  before_action :set_test_case_template_param_instance, :only => [:show, :delete, :update, :edit]

  # GET /test_case_template_param_instances
  # GET /test_case_template_param_instances.xml
  def index
    @test_case_template_param_instances = TestCaseTemplateParamInstance.all
  end

  # GET /test_case_template_param_instances/1
  # GET /test_case_template_param_instances/1.xml
  def show
  end

  # GET /test_case_template_param_instances/new
  # GET /test_case_template_param_instances/new.xml
  def new
    @test_case_template_param_instance = TestCaseTemplateParamInstance.new
    @test_case_template_id = params[:id]
  end

  #FIXME Memory allocate failures when one test case template instance hase too many test cases
  def delete
    test_case_template_param_instance = TestCaseTemplateParamInstance.find(params[:id])

    test_case_template_param = test_case_template_param_instance.test_case_template_param
    test_case_template = test_case_template_param_instance.test_case_template

    prev_raw_test_case_names = test_case_template_param_instance.raw_test_case_names

    begin
      if test_case_template_param.test_case_template_param_instances.size > 1 || test_case_template.test_case_template_params.size == 1
        prev_raw_test_case_names.every(100) do |partial_prev_raw_test_case_names|
          partial_prev_test_case_names = partial_prev_raw_test_case_names.map {|prev_raw_test_case_name| prev_raw_test_case_name.join('_')}

          test_cases = TestCase.where('test_target_id = ? and name in (?)', test_case_template.test_target_id, partial_prev_test_case_names).select('id')
          TestCase.batch_delete_all(test_cases)
        end
      else
        TestCase.batch_update_name(test_case_template.test_target_id, prev_raw_test_case_names) do |curr_raw_test_case_name|
          curr_raw_test_case_name.delete_at(test_case_template_param.seq + 1)
        end

        #Need to remove the test_case_template_param since it is empty
        test_case_template.test_case_template_params.each {|param| param.update(seq: param.seq - 1) if param.seq > test_case_template_param.seq}
      end

      test_case_template_param_instance.destroy
      test_case_template_param.destroy if test_case_template_param.deletable?
    rescue Exception => e
      puts e.inspect
      flash[:error] = "Fail to delete test case template param instance: #{test_case_template_param_instance.name} !"
    else
      flash[:notice] = "Delete test case template param instance: #{test_case_template_param_instance.name} successfully ! "
    end

    respond_to do |format|
      format.html {redirect_to(:controller => "test_case_templates", :action => "show", :id => test_case_template.id)}
    end
  end

  def create
    test_case_template_param = TestCaseTemplateParam.find(params[:test_case_template_param_instance][:test_case_template_param_id])
    test_case_template_param_instance_names = params[:test_case_template_param_instance][:names].lines.map(&:strip).reject(&:empty?).uniq

    begin
      TestCaseTemplateParamInstance.transaction do
        test_cases = TestCaseTemplateParamInstance.create_all(test_case_template_param, test_case_template_param_instance_names)
      end

      flash[:notice] = "#{test_cases.size} Cases Generated"
    rescue Exception => e
      flash[:error] = e.message + "\n" + e.backtrace.first
    end

    redirect_to(:controller => "test_case_templates", :action => "show", :id => test_case_template_param.test_case_template_id)
  end

  # GET /test_case_template_param_instances/1/edit
  def edit
  end

  def test_case_template_param_instance_params
    params.require(:test_case_template_param_instance).permit(:name)
  end

  def set_test_case_template_param_instance
    @test_case_template_param_instance = TestCaseTemplateParamInstance.find(params[:id])
  end

  def update
    prev_raw_test_case_names = @test_case_template_param_instance.raw_test_case_names

    begin
      TestCaseTemplateParamInstance.transaction do
        raise ActiveRecord::Rollback unless @test_case_template_param_instance.update(test_case_template_param_instance_params)

        TestCase.batch_update_name(@test_case_template_param_instance.test_case_template.test_target_id, prev_raw_test_case_names) do |curr_raw_test_case_name|
          curr_raw_test_case_name[@test_case_template_param_instance.test_case_template_param.seq + 1] = @test_case_template_param_instance.name
        end
      end

      flash[:notice] = "Update Success"
    rescue Exception => e
      flash[:error] = e.inspect
    end

    redirect_to(:controller => "test_case_templates", :action => "show", :id => @test_case_template_param_instance.test_case_template_param.test_case_template_id)
  end
end
