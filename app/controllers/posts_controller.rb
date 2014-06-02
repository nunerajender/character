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

  def author
    page = params[:page] || 1

    @author = Character::PostAuthor.find(params[:slug])
    @posts = @author.posts.published
    @posts = @posts.page(page).per(10)
  end

  def category
    page = params[:page] || 1

    @category = Character::PostCategory.find(params[:slug])
    @posts = @category.posts.published
    @posts = @posts.page(page).per(10)
  end

  def show
    @post = Character::Post.find(params[:slug])
  end

  def rss
    page = params[:page] || 1
    @posts = Character::Post.published.page(page).per(10)

    respond_to do |format|
      format.all { render :layout => false, content_type: 'text/xml; charset=utf-8' }
    end
  end
end