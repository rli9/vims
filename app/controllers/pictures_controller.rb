class PicturesController < ProjectsController
  skip_before_filter :validate_project_access_right?
  skip_before_filter :update_recent
  
  def picture
    @picture = Picture.find(params[:id])
    if @picture
      send_data(@picture.data, :type => @picture.content_type, :disposition => "inline")
    end
  end

end
