class SessionController < ApplicationController
  def new
  end

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
  
  def destroy
    session[:user_id] = nil
    session[:authenticated] = false
    redirect_to root_url :notice => "Successfully logged out."
  end
end