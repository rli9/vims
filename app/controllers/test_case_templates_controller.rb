class TestCaseTemplatesController < ProjectsController
  before_action :set_test_case_template, only: [:show, :edit, :update, :destroy]

  # GET /test_case_templates
  # GET /test_case_templates.xml
  def index
    @test_case_templates = TestCaseTemplate.where(test_target_id: session[:test_target_id])
    @test_case_template = TestCaseTemplate.new
  end

  # GET /test_case_templates/1
  # GET /test_case_templates/1.xml
  def show
  end

  # GET /test_case_templates/new
  # GET /test_case_templates/new.xml
  def new
    @test_case_template = TestCaseTemplate.new
  end

  # GET /test_case_templates/1/edit
  def edit
  end

  # POST /test_case_templates
  # POST /test_case_templates.xml
  def create
    @test_case_template = TestCaseTemplate.new(test_case_template_params)
    if @test_case_template.save
      flash[:notice] = 'TestCaseTemplate was successfully created.'
    else
      flash[:notice] = @test_case_template.errors.inspect
    end

    redirect_to :action => "index"
  end

  # PUT /test_case_templates/1
  # PUT /test_case_templates/1.xml
  def update
    prev_raw_test_case_names = @test_case_template.raw_test_case_names

    begin
      TestCaseTemplate.transaction do
        raise ActiveRecord::Rollback unless @test_case_template.update(test_case_template_params)

        test_case_name_prefix = @test_case_template.test_case_name_prefix
        TestCase.batch_update_name(@test_case_template.test_target_id, prev_raw_test_case_names) do |curr_raw_test_case_name|
          curr_raw_test_case_name[0] = test_case_name_prefix
        end
      end

      flash[:notice] = "Update Success"
    rescue Exception => e
      flash[:notice] = "Update Fail #{e}"
      flash[:error] = e.inspect
    end

    redirect_to @test_case_template
  end

  # DELETE /test_case_templates/1
  # DELETE /test_case_templates/1.xml
  def destroy
    @test_case_template.destroy if @test_case_template.deletable?

    respond_to do |format|
      format.html {redirect_to(test_case_templates_url)}
      format.xml {head :ok}
    end
  end

  private
    def test_case_template_params
      params.require(:test_case_template).permit(:name, :test_target_id)
    end

    def set_test_case_template
      @test_case_template = TestCaseTemplate.find(params[:id])
    end
end
