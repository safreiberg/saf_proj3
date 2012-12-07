class ApplicationController < ActionController::Base
  protect_from_forgery

  # Returns the authenticated user or nil. Depends on the
  # authentication invariants that:
  #   1) If a user is authenticated, session[authenticated]
  #      is true.
  #   2) If a user is not authenticated, session[authenticated]
  #      if false.
  #   3) If a user is authenticated, session[user_id] 
  #      contains that user's ID.
  def current_user
    if session[:authenticated]
      return User.find_by_id(session[:user_id])
    end
    return nil
  end
  helper_method :current_user
  
  # Redirects to root when there is no authenticated user.
  # Used as a filter for methods that need sign-in for 
  # access.
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_url
    end
  end
  helper_method :require_login

  # Returns true when a user is authenticated, else false.
  # Note: !! forces a boolean.
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?
  
  # Redirects to root when:
  #   1) There is no current authenticated user.
  #   2) The current user is not an admin.
  # Used as a filter for methods that need sign-in for 
  # access.
  def require_admin
    unless logged_in_admin?
      flash[:error] = "You must be admin for this resource!"
      redirect_to root_url
    end
  end
  helper_method :require_admin
  
  # Returns true when a user is authenticated and has his
  # admin flag set. Else false.
  def logged_in_admin?
    return logged_in? && current_user.admin
  end
  helper_method :logged_in_admin?
end
