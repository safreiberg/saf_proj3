class UserController < ApplicationController
  # Provides the object as a template for creating a 
  # new user.
  def new
    @user = User.new
  end

  # Shows information about the requested  user.
  def show
    @user = User.find_by_id(params[:id])
  end
  
  # Called by an asynchronous ajax request on show.html.erb
  # to update the posts made by this user. Simply returns all of the
  # posts that this user has ever made, in formatted form.
  def update_posts
    u = User.find_by_id(params[:id])
    if !u.nil?
      @posts = u.posts
    else
      @posts = []
    end
    render :layout => "update"
  end
  
  # Called by an asynchronous ajax request on show.html.erb
  # to update the comments made by this user. Simply returns all of the
  # comments that this user has ever made, in formatted form.
  def update_comments
    u = User.find_by_id(params[:id])
    if !u.nil?
      @comments = u.comments
    else
      @comments = []
    end
    render :layout => "user_comments"
  end
  
  # Called by an asynchronous ajax request on show.html.erb
  # display the statistics about a given user. The output is
  # html formatted by user_stats.html.erb.
  def update_stats
    @user = User.find_by_id(params[:id])
    render :layout => "user_stats"
  end

  # Users are currently final.
  def edit
  end
  
  def top
  end
  
  # Called by an asynchronous ajax request. Returns formatted HTML
  # that sorts all users by total karma and displays statistics about
  # them.
  def update_top
    @users = User.find(:all)
    @users = @users.sort_by &:total_karma
    render :layout => "user_short"
  end
  
  # Used to create a new user. This is specifically called from the "signup"
  # page, which is new.html.erb. This method (as explained in lower comments)
  # also checks if the user *already has* an account and has just forgotten.
  # In this case, if the password given was correct, then the user is signed
  # in.
  def create
    @user = User.new(params[:user])
    @user.admin = false
    @user.link_karma = 0
    @user.comment_karma = 0
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Your account has been created."
      session[:authenticated] = true
      redirect_to "/"
      return true
    else
      ## Let's attempt to log the user in, since they weren't able to create an account.
      ## This means that either 
      ##    (1) Account already claimed, and entered the right password
      ##    (2) Account already claimed, and entered the wrong password
      ##    (3) Account not claimed, and entered two different passwords
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
        redirect_to '/user/new'
        return false
      end
    end
  end
end
