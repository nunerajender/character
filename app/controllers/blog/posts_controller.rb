class Blog::PostsController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Not found.', status: 404, layout: false
  end

  before_filter :set_blog_parameters

  def set_blog_parameters
    @blog_domain      = ''
    @blog_title       = ''
    @blog_description = ''
    @blog_keywords    = ''
    @blog_disqus_shortname = ''
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

  def get_by_num
    @post = Character::Blog::Post.where(number: params[:num]).first
    if @post
      redirect_to blog_post_url(@post), status: :found
    else
      render text: 'Not found.', status: 404, layout: false
    end
  end

  def feed
    @posts = Character::Blog::Post.published

    respond_to do |format|
      format.rss { render :layout => false }
      format.all { head :not_found }
    end
  end
end