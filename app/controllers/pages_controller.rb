class PagesController < ApplicationController
  include WebsiteSettings
  include NotFound

  def show
    @object = Character::Page.find_by(path: '/' + (params[:path] || ''))
  end
end