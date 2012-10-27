class UserController < ApplicationController
  def new
    @user = User.new
  end

  def show
  end

  def edit
  end
  
  def create
    @user = User.new(params[:user])
    logger.debug("Just attempted to create a user.")
    if @user.save
      logger.debug("Your account has been created")
      session[:user_id] = @user.id
      flash[:notice] = "Your account has been created."
      session[:authenticated] = true
      ## TODO
      ## Mail.welcome_email(@user).deliver
      redirect_to "/"
      return true
    else
      ## Let's attempt to log the user in, since they weren't able to create an account.
      ## This means that either 
      ##    (1) Account already claimed, and entered the right password
      ##    (2) Account already claimed, and entered the wrong password
      ##    (3) Account not claimed, and entered two different passwords
      logger.debug("Failure :( to create new account.")
      logger.debug(params[:user][:email].to_s)
      user = User.find_by_email(params[:user][:email])
      if user && user.authenticate(params[:user][:password])
        ##    This is case 1.
        session[:user_id] = user.id
        flash[:notice] = "You already had an account. We went ahead and signed you in :)."
        session[:authenticated] = true
        redirect_to '/'
        return true
      elsif user
        ##    Case 2.
        logger.debug("Signin failed.")
        if @user = User.where(:email => params[:user][:email]).first
          flash[:notice] = "That email or username is already taken."
          session[:authenticated] = false
          render '/user/new'
          return false
        end
      else
        # Case 3
        flash[:notice] = "Password confirmation was incorrect."
        session[:authenticated] = false
        logger.debug("Couldn't even log them in.")
        redirect_to '/user/new'
        return false
      end
    end
  end
end
