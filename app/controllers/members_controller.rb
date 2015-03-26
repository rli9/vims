class MembersController < ProjectsController
  skip_before_filter :validate_vims_access_right?, :only => [:new, :create]
  skip_before_filter :validate_project_access_right?
  skip_before_filter :update_recent, :only => [:new, :create]

  def edit

  end

  def update_info
    if params[:picture] && params[:picture][:picture] != ''
      @picture = Picture.new(params[:picture])
      @member.picture = @picture if @picture.save
    end

    if @member.update(:name => params[:member][:name], :email => params[:member][:email])
      flash[:notice] = "Your information is updated!"
    end

    render :action => 'edit', :id => 0
  end

  def update_password
    if @member.validate_password?(params[:old_password])
      @member.hashed_password = nil
      if params[:member][:password] == params[:con_password]
        if @member.update(params[:member])
          flash[:notice] = "Your Password is Changed!"
          flash[:pswnotice] = ''
        end
      else
        flash[:pswnotice] = 'Confirm password fail, please check you password'
      end
    else
      flash[:pswnotice] = 'Old Password Error'
    end
    render :action => 'edit', :id => 0
  end

  def new
    @member = Member.new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(params[:picture])
    @member = Member.new(params[:member])

    #FIXME add transaction
    if @picture.save
      @member.picture = @picture
      if @member.save
        redirect_to :controller => 'intelligents', :action => 'index'
      else
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end

  private
    def member_params
      params.require(:member).permit(:name, :password)
    end
end
