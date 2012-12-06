class SessionController < ApplicationController
  def new
  end

  # Authenticates a user login. Effects:
  #   1) Asserts that the request contains the correct username
  #      and password.
  #   2) Sets the appropriate session hash values if authentication
  #      was successful.
  #   3) Fails if authentication was not successful, and redirects
  #      the user to the sign-in page.
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:authenticated] = true
      redirect_to root_url, :notice => "Successfully logged in."
      return
    else
      flash.now.alert = "Invalid email or password"
      render 'new'
    end
  end
  
  # Destroys the current session information (logout action).
  # Effects:
  #   1) Unset the necessary session values.
  #   2) Redirect to root.
  def destroy
    session[:user_id] = nil
    session[:authenticated] = false
    flash.now.alert = "Successfully logged out."
    redirect_to root_url
  end
end