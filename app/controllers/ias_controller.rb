class IasController < ApplicationController
  def index
    redirect_to :controller => 'bits_interpreters', :action => 'index'
  end
end
