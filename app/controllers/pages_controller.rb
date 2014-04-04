class PagesController < ApplicationController
  include WebsiteSettings

  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Page not found.', status: 404, layout: false
  end

  def show
    # TODO: this doesn't trigger PAGE NOT FOUND for some reason
    @object = Character::Page.find_by(path: params[:path])
  end
end