class PostsController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Not found.', status: 404, layout: false
  end

  before_filter :set_blog_parameters

  def index
    @posts = Character::Post.published
  end

  def category
    @category = Character::PostCategory.find(params[:slug])
    @posts    = @category.posts.published
    render 'index'
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

  private

  def set_blog_parameters
    settings     = ::Settings.group('Website Settings')
    @domain      = settings['Domain'].value
    @title       = settings['Title'].value
    @description = settings['Description'].value
    @keywords    = settings['Keywords'].value
  end
end