# Author: Alexander Kravets
#         Slate, 2013

class Character::BaseController < ActionController::Base
  include NamespaceHelper

  layout false

  before_filter :authenticate_user

  def authenticate_user
    if Rails.env.development? and character_namespace.no_auth_on_development
      @admin_user = character_namespace.user_class.first
    else
      if browserid_authenticated?
        @admin_user = browserid_current_user
      else
        render status: :unauthorized, json: { error: "Access denied." }
      end
    end
  end

  # Overrides browserid-auth-rails config with session dependent values
  def browserid_config
    @browserid_config ||= begin
      config = Rails.configuration.browserid.clone
      config.user_model       = character_namespace.user_model
      config.session_variable = "#{ character_namespace.name }_browserid_email"
      config.login.text       = 'Sign-in with Persona'
      config.login.path       = "/#{ character_namespace.name }/login"
      config.logout.path      = "/#{ character_namespace.name }/logout"
      config
    end
  end

end
