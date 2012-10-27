class PostsController < ApplicationController
  def show
    @post = Post.find_by_id(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def index
    @posts = Post.limit(10)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @posts }
    end
  end

  def create
  end

  def new
  end
  
  def add_comment
    ## Prevent commenting in someone else's name
    if session[:user_id].to_i == params[:user_id].to_i
      comment = Comment.new(:user_id => params[:user_id], :post_id => params[:post_id], :content => params[:content])
      if comment.save
        flash[:notice] = "Successfully added comment."
      else
        flash[:notice] = "Oops! Something went wrong."
      end
    end
    redirect_to "/posts/show/" + params[:post_id].to_s
  end
  
  def add_post
    ## Prevent commenting in someone else's name
    if session[:user_id].to_i == params[:user_id].to_i
      post = Post.new(:user_id => params[:user_id], :content => params[:content], :title => params[:title])
      if post.save
        flash[:notice] = "Successfully added post."
      else
        flash[:notice] = "Oops! Something went wrong."
      end
    end
    redirect_to "/posts/index/"
  end
  
  def update 
    logger.debug("updated");
    @posts = Post.limit(10)
    
    render :layout => "update"
  end
  
  def update_comments
    logger.debug("updated comments")
    @comments = Comment.where(:post_id => params[:id])
    
    render :layout => "update_comments"
  end
end
