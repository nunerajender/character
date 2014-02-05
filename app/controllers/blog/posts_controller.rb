class Blog::PostsController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Not found.', status: 404, layout: false
  end

  before_filter :set_blog_parameters

  def set_blog_parameters
    settings = ::Settings.group('Blog Settings')
    @blog_domain            = settings['Domain'].value
    @blog_title             = settings['Title'].value
    @blog_description       = settings['Description'].value
    @blog_keywords          = settings['Keywords'].value
  end

  def index
    category_slug = params[:category]
    @posts        = []

    if category_slug.nil?
      @posts = Character::Blog::Post.published
    else
      @category = Character::Blog::Category.find(category_slug)
      @posts = @category.posts.published
    end
    render layout: 'application'
  end

  def show
    @post = Character::Blog::Post.find(params[:slug])
    render layout: 'application'
  end

  def feed
    @posts = Character::Blog::Post.published

    respond_to do |format|
      format.rss { render :layout => false }
      format.all { head :not_found }
    end
  end
end