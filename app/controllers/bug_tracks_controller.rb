class BugTracksController < ProjectsController
  before_action :set_bug_track, only: [:show, :edit, :update, :destroy]

  def index
    test_target = TestTarget.find(session[:test_target_id])
    @bug_tracker_url = test_target.bug_config ? test_target.bug_config.url : ""

    @open_bugs = Bug.where('bug_status != ?', 'CLOSED').includes(:profile).select('bug_id, short_desc, reporter')

    open_bug_ids = @open_bugs.map(&:bug_id)
    @bug_ids_bug_tracks = BugTrack.where(test_target_id: session[:test_target_id]).includes(:test_case).group_by(&:bug_id)
    @bug_ids_bug_tracks.select! {|key, value| open_bug_ids.include? key}

    @unmapped_bugs = @open_bugs.select {|bug| !@bug_ids_bug_tracks.keys.include?(bug.bug_id) &&
                                              BUGZILLA_CONFIG["qa_emails"].include?(bug.profile.login_name)}
  end

  def new
    @bug_track = BugTrack.new(bug_track_params)
  end

  def edit
  end

  def search
    @key_words = params[:key_words] && params[:key_words].strip
    @test_cases = []
    if @key_words && !@key_words.empty?
      key_words = Regexp.escape(@key_words).downcase
      @test_cases = TestCase.where(["test_target_id = ? AND name like ?", session[:test_target_id], "%" + key_words + "%"])
    end
    render :template => 'bug_tracks/search'
  end

  def create
    @bug_track = BugTrack.new(bug_track_params)
    if @bug_track.save
      flash[:notice] = "New Bug Add Successful"
    else
      flash[:notice] = @bug_track.inspect
    end

    redirect_to :controller => "bug_tracks", :action => "index"
  end

  def config_address
    @bug_configs = BugConfig.where(test_target_id: session[:test_target_id])
  end

  def create_config
    bug_config = BugConfig.new
    bug_config.test_target_id = session[:test_target_id]
    bug_config.url = params[:url]
    flash[:notice] = "New Bug Config Add Successful" if bug_config.save
    redirect_to :controller => "bug_tracks", :action => "config_address", :id => 0
  end

  def update_config
    bug_config = BugConfig.find(params[:id])
    bug_config.url = params[:url]
    flash[:notice] = "Update Bug Config Successful" if bug_config.save
    redirect_to :controller => "bug_tracks", :action => "config_address", :id => 0
  end

  def map_bug_to_case

  end

  def create_by_test_case_names
    test_case_names = params[:bug_track][:test_case_names].lines.uniq

    if test_case_names.nil? || test_case_names.empty?
      flash[:notice] = "Please input test case name(s)"
      #FIXME do we return error status?
    else
      test_case_names = test_case_names.reject do |test_case_name|
        BugTrack.new(bug_track_params.merge(test_case_name: test_case_name)).save
      end

      unless test_case_names.empty?
        flash[:notice] = "#{test_case_names.size} test cases mapping fails: #{test_case_names.join(',')}"
      else
        flash[:notice] = "Mapping test cases and bug id successfully !!"
      end
    end

    redirect_to :controller => "bug_tracks", :action => "map_bug_to_case"
  end

  def update
    if @bug_track.update(bug_track_params)
      flash[:notice] = "Update 1 bug track !"
    else
      flash[:error] = 'Update bug track failed!'
    end

    redirect_to :controller => "bug_tracks", :action => "index"
  end

  def destroy
    if @bug_track.destroy
      flash[:notice] = "Delete 1 bug track !"
    else
      flash[:error] = 'Delete bug track failed!'
    end

    redirect_to :controller => "bug_tracks", :action => "index"
  end

  def show
    @bug_tracks = []
    bug_tracks = BugTrack.where(test_target_id: session[:test_target_id], :order => "test_case_id")
    if bug_tracks && bug_tracks.size > 1
      bug_tracks.each_index do |index|
        next if bug_tracks[index].test_case_id == bug_tracks[index - 1].test_case_id
        @bug_tracks << bug_tracks[index]
      end
    end
  end

  private
    def set_bug_track
      @bug_track = BugTrack.find(params[:id])
    end

    def bug_track_params
      params.require(:bug_track).permit(:bug_id, :test_case_id, :test_target_id, :test_case_name)
    end
end
