class TestCaseTemplateParamsController < ProjectsController
  before_action :set_test_case_template_param, only: [:update]

  def show
    @test_case_template = TestCaseTemplate.find(params[:id])
  end

  def delete
    test_case_template_param = TestCaseTemplateParam.find(params[:id])

    if test_case_template_param.destroy
      flash[:notice] = "Delete #{test_case_template_param.name} successfully"
    end

    redirect_to_test_case_templates(test_case_template_param)
  end

  def move_down
    up_test_case_template_param = TestCaseTemplateParam.find(params[:id])
    down_test_case_template_param = TestCaseTemplateParam.find_by(test_case_template_id: up_test_case_template_param.test_case_template_id, seq: up_test_case_template_param.seq + 1)

    switch(up_test_case_template_param, down_test_case_template_param)

    @test_case_template = up_test_case_template_param.test_case_template
    render :show
  end

  def move_up
    down_test_case_template_param = TestCaseTemplateParam.find(params[:id])
    up_test_case_template_param = TestCaseTemplateParam.find_by(test_case_template_id: down_test_case_template_param.test_case_template_id, seq: down_test_case_template_param.seq - 1)

    switch(up_test_case_template_param, down_test_case_template_param)

    @test_case_template = down_test_case_template_param.test_case_template
    render :show
  end

  def switch(up_test_case_template_param, down_test_case_template_param)
    begin
      TestCaseTemplateParam.transaction do
        test_case_template = up_test_case_template_param.test_case_template

        TestCase.batch_update_name(test_case_template.test_target_id, test_case_template.raw_test_case_names) do |curr_raw_test_case_name|
          curr_raw_test_case_name[down_test_case_template_param.seq + 1], curr_raw_test_case_name[up_test_case_template_param.seq + 1] =
          curr_raw_test_case_name[up_test_case_template_param.seq + 1], curr_raw_test_case_name[down_test_case_template_param.seq + 1]
        end

        down_test_case_template_param.seq -= 1
        up_test_case_template_param.seq += 1

        raise ActiveRecord::Rollback unless down_test_case_template_param.save && up_test_case_template_param.save
      end

      flash[:notice] = "Update success"
    rescue Exception => e
      flash[:notice] = e.message + "\n" + e.backtrace.first
    end
  end

  def create
    #test_case_template_param = TestCaseTemplateParam.new(test_case_template_param_params)

    test_case_template_param = TestCaseTemplateParam.new(params.require(:new_test_case_template_param).permit(:name, :test_case_template_id))
    test_case_template_param.seq = TestCaseTemplateParam.where(test_case_template_id: test_case_template_param.test_case_template_id).size

    begin
      TestCaseTemplateParam.transaction do
        raise ActiveRecord::Rollback unless test_case_template_param.save
        # test_cases = TestCaseTemplateParamInstance.create_all(test_case_template_param, [test_case_template_param.id])
        # flash[:notice] = "#{test_cases.size} Cases Generated"
      end
    rescue Exception => e
      flash[:notice] = e.inspect
    end

    redirect_to_test_case_templates(test_case_template_param)
  end

  def update
    respond_to do |format|
      if @test_case_template_param.update(test_case_template_param_params)
        flash[:notice] = 'TestCaseTemplate was successfully updated.'

        format.html {redirect_to_test_case_templates(@test_case_template_param)}
        format.xml {head :ok}
      else
        format.html {redirect_to_test_case_templates(@test_case_template_param)}
        format.xml {render :xml => @test_case_template_param.errors, :status => :unprocessable_entity}
      end
    end
  end

  private
  def set_test_case_template_param
    @test_case_template_param = TestCaseTemplateParam.find(params[:id])
  end

  def test_case_template_param_params
    params.require(:test_case_template_param).permit(:name, :test_case_template_id)
  end

  def redirect_to_test_case_templates(test_case_template_param)
    #redirect_to(:controller => "test_case_templates", :action => "show", :id => test_case_template_param.test_case_template_id)
    redirect_to(:controller => "test_case_templates", :action => "index")
  end
end
