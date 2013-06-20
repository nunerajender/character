class Character::Admin::AdminController < Character::Admin::BaseController
  layout false

  def index
    # - this is a way to generate a list of models which do should be
    #   editable via admin interface.
    # TODO: check if this method is still valid after changes to be made.

    @admin_models = ::Rails.application.config.character_admin_models.reject do |name|
      ['Character::Post', 'Character::Page'].include? name
    end.collect{ |name| name.constantize }

    render 'character/admin/index'
  end
end