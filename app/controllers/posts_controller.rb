class PostsController < ApplicationController
  include WebsiteSettings

  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Post not found.', status: 404, layout: false
  end

  def index
    @posts = Character::Post.published
  end

  def category
    @category = Character::PostCategory.find(params[:slug])
    @posts    = @category.posts.published
  end

  def show
    @post = Character::Post.find(params[:slug])
  end

  def feed
    @posts = Character::Post.published

    respond_to do |format|
      format.rss { render :layout => false }
      format.all { head :not_found }
    end
  end
end