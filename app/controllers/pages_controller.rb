class PagesController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Not found.', status: 404, layout: false
  end

  def show
    @object = Character::Page.find_by(path: params[:path])
  end
end