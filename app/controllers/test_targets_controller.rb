class TestTargetsController < ProjectsController
  def index
    @test_targets = TestTarget.all
  end

  def show
    @test_target = TestTarget.find(params[:id])
  end

  def new
    @test_target = TestTarget.new
  end

  def edit
    @test_target = TestTarget.find(params[:id])
  end

  def create
    @test_target = TestTarget.new(params[:test_target])
    if @test_target.save
      flash[:notice] = "TestTarget #{@test_target.name} was successfully created."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def update
    @test_target = TestTarget.find(params[:id])
    if @test_target.update(params[:test_target])
      flash[:notice] = "TestTarget #{@test_target.name} was successfully update."
      redirect_to :action => 'index'
    else
      render :action => 'edit', :id => 0
    end
  end

  def destroy
    @test_target = TestTarget.find(params[:id])
    if @test_target.deletable?
      if @test_target.destroy
        flash[:notice] = "TestTarget #{@test_target.name} was successfully deleted."
        redirect_to :action => 'index'
      end
    end
  end
end