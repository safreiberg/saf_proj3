class PostsController < ApplicationController
  def show
    @post = Post.find_by_id(params[:id])
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
  
  def update 
    logger.debug("updated");
    @posts = Post.limit(10)
    
    render :layout => "update"
  end
end
