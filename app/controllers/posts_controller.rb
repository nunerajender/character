class PostsController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Not found.', status: 404, layout: false
  end

  before_filter :set_website_settings

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

  private

  def set_website_settings
    settings     = ::Settings.group('Website Settings')
    @domain      = settings['Domain'].value
    @title       = settings['Title'].value
    @description = settings['Description'].value
  end
end