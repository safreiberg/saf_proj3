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
  
  def uppost
    if session[:authenticated]
      pv = PostVote.where(:post_id => params[:id], :user_id => session[:user_id]).first
      if pv && !pv.up
        Post.find_by_id(params[:id]).decrement_downvotes
        pv.destroy
      end
      if pv.nil?
        Post.find_by_id(params[:id]).increment_upvotes
        PostVote.create(:post_id => params[:id], :user_id => session[:user_id], :up => true)
      end
    end
  end
  
  def downpost
    if session[:authenticated]  
      pv = PostVote.where(:post_id => params[:id], :user_id => session[:user_id]).first
      if pv && pv.up
        Post.find_by_id(params[:id]).decrement_upvotes
        pv.destroy
      end
      if pv.nil?
        Post.find_by_id(params[:id]).increment_downvotes
        PostVote.create(:post_id => params[:id], :user_id => session[:user_id], :up => false)
      end
    end
  end
  
  def upcomment
    if session[:authenticated]
      cv = CommentVote.where(:comment_id => params[:id], :user_id => session[:user_id]).first
      if cv && !cv.up
        Comment.find_by_id(params[:id]).decrement_downvotes
        cv.destroy
      end
      if cv.nil?
        Comment.find_by_id(params[:id]).increment_upvotes
        CommentVote.create(:comment_id => params[:id], :user_id => session[:user_id], :up => true)
      end
    end
  end
  
  def downcomment
    if session[:authenticated]  
      cv = CommentVote.where(:comment_id => params[:id], :user_id => session[:user_id]).first
      if cv && cv.up
        Comment.find_by_id(params[:id]).decrement_upvotes
        cv.destroy
      end
      if cv.nil?
        Comment.find_by_id(params[:id]).increment_downvotes
        CommentVote.create(:comment_id => params[:id], :user_id => session[:user_id], :up => false)
      end
    end
  end
  
  def add_comment
    ## Prevent commenting in someone else's name
    if session[:user_id].to_i == params[:user_id].to_i
      comment = Comment.new(:user_id => params[:user_id], :post_id => params[:post_id], :content => params[:content], :upvotes => 0, :downvotes => 0, :rank => 0)
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
      post = Post.new(:user_id => params[:user_id], :content => params[:content], :title => params[:title], :upvotes => 0, :downvotes => 0, :rank => 0)
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
    @posts = Post.order("rank DESC")
    
    render :layout => "update"
  end
  
  def update_comments
    logger.debug("updated comments")
    @comments = Comment.where(:post_id => params[:id]).order("rank DESC")
    
    render :layout => "update_comments"
  end
end
