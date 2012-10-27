class PostsController < ApplicationController
  def show
  end

  def edit
  end

  def index
    @posts = Post.limit(10)
  end

  def create
  end

  def new
  end
end
