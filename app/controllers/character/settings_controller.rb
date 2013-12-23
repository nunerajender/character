# Author: Alexander Kravets
#         Slate, 2013

class Character::SettingsController < ActionController::Base
  include InstanceHelper

  include AuthHelper
  before_filter :authenticate_user

  layout :false

  def show
    scope         = params[:scope]
    template_name = scope.gsub('-', '_')

    if template_exists?(template_name, "character/settings", false)
      render "character/settings/#{ template_name }"
    else
      render text: 'Settings template not found.'
    end
  end

  def update
    errors     = {}
    class_name = params[:class_name]
    objects    = params[:objects].first

    model_class = class_name.constantize

    objects.each_pair do |id_or_slug, attributes|

      begin
        object = model_class.find id_or_slug
      rescue Mongoid::Errors::DocumentNotFound
        object = model_class.new
      end

      if attributes[:_destroy] == 'true'
        object.destroy
      else
        unless object.update_attributes(attributes)
          errors[object_id] = object.errors
        end
      end

    end

    # TODO: error handling
    render json: errors
  end

  private

  def authenticate_user
    if not auto_login!
      if browserid_authenticated? then login! else render status: :unauthorized, json: { error: "Access denied." } end
    end
  end
end