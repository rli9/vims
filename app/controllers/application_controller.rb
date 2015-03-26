# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'zlib'
require 'stringio'

class ApplicationController < ActionController::Base
  before_filter :access?, :except => [:login]
  around_filter :profiling, :except => :login

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '50bce8d835d4f0c437c38bffbe6e08a1'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound, ActionController::UnknownAction
      render(:file => "#{Rails.root}/public/404.html", :status => "404 Not Found")
    else
      render(:file => "#{Rails.root}/public/500.html", :status => "500 Error")
      SystemMailer.deliver_exception_notification(self, request, exception)
    end
  end

  def login
    if request.post?
      @member = Member.new(member_params)
      if Member.authenticate?(@member)
        session[:member_id] = Member.find_by_name(@member.name).id
        if session[:user_input_link]
          first_url = session[:user_input_link]
          session[:user_input_link] = nil
          redirect_to first_url
        else
          redirect_to :controller => 'projects', :action => 'index'
        end
      else
        @member.password = nil
        flash[:notice] = 'Wrong name or password, retry'
      end
    else
      logout if member_authenticated?
    end
  end

  def logout
    session[:project_id] = nil
    session[:test_target_id] = nil
    session[:member_id] = nil
    @member = nil

    redirect_to_login
  end

  private
    def compress
      http_accept_encoding = request.env['HTTP_ACCEPT_ENCODING']
      return unless http_accept_encoding && http_accept_encoding =~ /(x-gzip|gzip)/

      content_encoding = $1
      output = StringIO.new

      def output.close
        rewind
      end

      gz = Zlib::GzipWriter.new(output)
      gz.write(response.body)
      gz.close

      if output.length < response.body.length
        response.body = output.string
        response.headers['Content-encoding'] = content_encoding
      end
    end

    def access?
      unless member_authenticated?
        session[:user_input_link] = request.url
        redirect_to_login
        return false
      else
        @member = Member.find(session[:member_id])
        return true
      end
    end

    def member_authenticated?
      session[:member_id]
    end

    def redirect_to_login
      redirect_to '/login'
    end

    def profiling
      time = Time.now
      yield
      time = Time.now - time
      response.body = response.body.sub("<div id=\"profile\"></div>", "#{time}s")
    end

    def member_params
      params.require(:member).permit(:name, :password)
    end
end

