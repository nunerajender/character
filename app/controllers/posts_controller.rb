class PostsController < ApplicationController
  include WebsiteSettings
  include NotFound

  def index
    page             = params[:page] || 1
    @search          = params[:q] || ''
    @kaminari_params = @search.empty? ? {} : { q: @search }

    @posts = Character::Post.published
    @posts = @posts.search(@search) if not @search.empty?
    @posts = @posts.page(page).per(10)
  end

  def category
    page    = params[:page] || 1

    @category = Character::PostCategory.find(params[:slug])
    @posts = @category.posts.published
    @posts = @posts.page(page).per(10)
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