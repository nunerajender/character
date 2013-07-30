# Author: Alexander Kravets
#         Slate, 2013

class Character::SettingsController < ActionController::Base

  def show
    scope = params[:scope]
    # TODO: add template check here
    render "character/admin/settings/#{ scope }"
  end


  def update
    errors     = {}
    class_name = params[:class_name]
    objects    = params[:objects].first

    model_class = class_name.constantize

    objects.each_pair do |object_id, attributes|
      

      object = model_class.where(id: object_id).first

      if not object
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

end

