class PagesController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render text: 'Not found.', status: 404, layout: false
  end

  before_filter :set_website_settings

  def show
    @object = Character::Page.find_by(path: params[:path])
  end

  private

  def set_website_settings
    settings     = ::Settings.group('Website Settings')
    @domain      = settings['Domain'].value
    @title       = settings['Title'].value
    @description = settings['Description'].value
    @keywords    = settings['Keywords'].value
  end
end