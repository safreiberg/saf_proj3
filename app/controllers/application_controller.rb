class ApplicationController < ActionController::Base
  protect_from_forgery
  def current_user
    if session[:authenticated]
      return User.find_by_id(session[:user_id])
    end
    return nil
  end
  
  helper_method :current_user
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_url
    end
  end
  
  helper_method :require_login

  def logged_in?
    !!current_user
  end
end
