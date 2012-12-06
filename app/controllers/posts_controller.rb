class PostsController < ApplicationController
  before_filter :require_login, only: [:uppost, :downpost, :upcomment, :downcomment, :add_comment, :add_post]
  
  # Show the text of a Post. This also shows the Comments
  # on a post, as well as allows voting and adding comments
  # for users.
  def show
    @post = Post.find_by_id(params[:id])
    @comment = Comment.new
  end

  # Currently comments and posts are final.
  def edit
    redirect_to :root
  end

  # Shows a list of all of the Posts.
  def index
    @posts = Post.find(:all)
  end

  # Create and New are not currently used.
  def create
    redirect_to :root
  end
  def new
    redirect_to :root
  end
  
  ## Upvote a post
  # This method is called by an asynch ajax request
  # from the index page. The logic of karma, etc, is 
  # delegated to the Post and User controllers.
  def uppost
    post = Post.find_by_id(params[:id])
    if !post.nil?
      post.vote(current_user, true)
    end
  end
  
  ## Downvote a post
  # This method is called by an asynch ajax request
  # from the index page. The logic of karma, etc, is 
  # delegated to the Post and User controllers.
  def downpost
    post = Post.find_by_id(params[:id])
    if !post.nil?
      post.vote(current_user, false)
    end
  end
  
  ## Upvote a comment
  # This method is called by an asynch ajax request
  # from the show page. The logic of karma, etc, is 
  # delegated to the Post and User controllers. 
  # The current functionality is the same as Posts, 
  # but the modularity allows later change.
  def upcomment
    comm = Comment.find_by_id(params[:id])
    if !comm.nil?
      comm.vote(current_user, true)
    end
  end
  
  ## Downvote a comment
  # This method is called by an asynch ajax request
  # from the show page. The logic of karma, etc, is 
  # delegated to the Post and User controllers. 
  # The current functionality is the same as Posts, 
  # but the modularity allows later change.
  def downcomment
    comm = Comment.find_by_id(params[:id])
    if !comm.nil?
      comm.vote(current_user, false)
    end
  end
  
  # This method is called by an asynch ajax request 
  # from the show page when an authenticated user
  # submits a "New Comment" form.
  # Effects:
  #   1) Check that current_user is valid, and that
  #      he is not trying to comment as someone else.
  #   2) Create a new comment
  def add_comment
    if current_user.id.to_s == params[:user_id].to_s
      comment = Comment.new(:user_id => params[:user_id], :post_id => params[:post_id],\
       :content => params[:content], :upvotes => 0, :downvotes => 0, :rank => 0)
      comment.save!
    end
  end
  
  # This method is called by an asynch ajax request 
  # from the index page when an authenticated user
  # submits a "New Post" form.
  # Effects:
  #   1) Check that current_user is valid, and that
  #      he is not trying to post as someone else.
  #   2) Create a new post
  def add_post
    if current_user.id.to_s == params[:user_id].to_s
      post = Post.new(:user_id => params[:user_id], :content => params[:content],\
       :title => params[:title], :upvotes => 0, :downvotes => 0, :rank => 0)
      post.save!
    end
  end
  
  # Called from an asynch ajax request from the
  # index page every time a short poll occurs that 
  # updates the Post view.
  def update 
    @posts = Post.order("rank DESC")
    render :layout => "update"
  end
  
  # Called from an asynch ajax request from the
  # show page every time a short poll occurs that 
  # updates the Comment view for a given Post.
  # 
  # In the event of invalid ID, returning a blank
  # array for @comments will render a blank page to 
  # the user (Principle of Least Astonishment).
  def update_comments
    post = Post.find_by_id(params[:id])
    if !post.nil?
      @comments = post.comments.order("rank DESC")
    else
      @comments = []
    end
    render :layout => "update_comments"
  end
end
