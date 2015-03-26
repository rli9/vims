class ProjectsController < ApplicationController
  #FIXME child controllers need check too
  before_action :set_project, :except => [:new, :create, :index, :manage]

  def index
    @projects = Member.find(session[:member_id]).projects.includes([:test_target], [:creator])
  end

  def new
    @project = Project.new
    @test_target = TestTarget.new
  end

  def add_member
    #FIXME how to check the error of <<
    @project.members << Member.find(params[:member_id])

    redirect_to :action => 'manage', :id => session[:project_id], notice: "Member has been added to Projects."
  end

  def create
    begin
      Project.transaction do
        @project = Project.new(project_params.merge(created_by: session[:member_id], updated_by: session[:member_id]))
        raise ActiveRecord::Rollback unless @project.save

        @test_target = TestTarget.new(test_target_params.merge(project_id: @project.id))
        raise ActiveRecord::Rollback unless @test_target.save

        @project.members << Member.find(session[:member_id])
      end

      flash[:notice] = "Project '#{@project.name}' was successfully created."
      redirect_to :action => 'index'
    rescue
      flash[:notice] = "Create Project Fail"
      render :action => 'new'
    end
  end

  def delete
    test_target = @project.test_target
    test_target.destroy if test_target.deletable?
    @project.destroy if project.deletable?

    redirect_to :action => 'index'
  end

  def edit
    @test_target = @project.test_target
  end

  def update
    #FIXME trasaction is needed
    if @project.update(project_params.merge(updated_by: session[:member_id]))
      @project.test_target.update(test_target_params)

      flash[:notice] = "Project \"#{project.name}\" has been updated."
      redirect_to :controller => 'projects', :action => 'index'
    else
      render :action => 'edit', :id => 0
    end
  end

  def manage
    @project = Project.find(params[:id])
    if @project.members.exists? Member.find(session[:member_id])
      session[:project_id] = @project.id
      session[:test_target_id] = @project.test_target.id
      @members = @project.members
    else
      session[:project_id] = session[:test_target_id] = nil

      redirect_to :controller => 'projects', :action => 'index'
    end
  end

  protected
    def set_project
      unless session[:project_id]
        redirect_to :controller => 'projects', :action => 'index'
      else
        @project = Project.find(session[:project_id])
      end
    end

  private
    def project_params
      params.require(:project).permit(:name)
    end

    def test_target_params
      params.require(:test_target).permit(:name)
    end
end
