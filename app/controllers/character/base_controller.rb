# Author: Alexander Kravets, Roman Lupiychuk
#         Slate, 2013

class Character::BaseController < ActionController::Base
  include InstanceHelper

  layout false

  before_filter :authenticate_user
  before_filter :check_permissions

  # Overrides browserid-auth-rails config with session dependent values
  def browserid_config
    @browserid_config ||= begin
      config = Rails.configuration.browserid.clone
      config.user_model       = character_instance.user_model
      config.session_variable = "#{ character_instance.name }_browserid_email"
      config.login.text       = 'Sign-in with Persona'
      config.login.path       = "/#{ character_instance.name }/login"
      config.logout.path      = "/#{ character_instance.name }/logout"
      config
    end
  end

  private

  def authenticate_user
    if browserid_authenticated?
      @current_user = browserid_current_user
    else
      render status: :unauthorized, json: { error: "Access denied." }
    end
  end


  def check_permissions
    filter = character_instance.permissions_filter
    if filter.nil? || self.instance_exec(&filter)
      true
    else
      render status: :unauthorized, json: { error: "Access denied." }
    end
  end
end