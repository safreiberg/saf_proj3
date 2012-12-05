class PostsController < ApplicationController
  before_filter :require_login, only: [:uppost, :downpost, :upcomment, :downcomment, :add_comment, :add_post]
  
  # 
  def show
    @post = Post.find_by_id(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def index
    @posts = Post.find(:all)
  end

  def create
  end

  def new
  end
  
  ## Upvote a post
  def uppost
    post = Post.find_by_id(params[:id])
    if !post.nil?
      post.vote(current_user, true)
    end
  end
  
  ## Downvote a post
  def downpost
    post = Post.find_by_id(params[:id])
    if !post.nil?
      post.vote(current_user, false)
    end
  end
  
  ## Upvote a comment
  def upcomment
    comm = Comment.find_by_id(params[:id])
    if !comm.nil?
      comm.vote(current_user, true)
    end
  end
  
  ## Downvote a comment
  def downcomment
    comm = Comment.find_by_id(params[:id])
    if !comm.nil?
      comm.vote(current_user, false)
    end
  end
  
  def add_comment
    ## Prevent commenting in someone else's name
    if current_user.id == params[:user_id]
      comment = Comment.new(:user_id => params[:user_id], :post_id => params[:post_id],\
       :content => params[:content], :upvotes => 0, :downvotes => 0, :rank => 0)
      if comment.save
        flash[:notice] = "Successfully added comment."
      else
        flash[:notice] = "Oops! Something went wrong."
      end
    end
    redirect_to "/posts/show/" + params[:post_id].to_s
  end
  
  def add_post
    ## Prevent posting in someone else's name
    if current_user.id == params[:user_id]
      post = Post.new(:user_id => params[:user_id], :content => params[:content],\
       :title => params[:title], :upvotes => 0, :downvotes => 0, :rank => 0)
      if post.save
        flash[:notice] = "Successfully added post."
      else
        flash[:notice] = "Oops! Something went wrong."
      end
    end
    redirect_to "/posts/index/"
  end
  
  def update 
    @posts = Post.order("rank DESC")
    render :layout => "update"
  end
  
  def update_comments
    post = Post.find_by_id(params[:id])
    @comments = post.comments.order("rank DESC")    
    render :layout => "update_comments"
  end
end
