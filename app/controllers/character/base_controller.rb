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
      initialize_browserid

      if browserid_authenticated?
        @admin_user = browserid_current_user
      else
        render status: :unauthorized, json: { error: "Access denied." }
      end
    end
  end

  private

  def initialize_browserid
    # FIXME: There might be issues during concurrent requests,
    #        find better solution

    browserid_config = Rails.configuration.browserid
    browserid_config.user_model       = character_namespace.user_model
    browserid_config.session_variable = "#{ character_namespace.name }_browserid_email"
    browserid_config.login.text       = 'Sign-in with Persona'
    browserid_config.login.path       = "/#{ character_namespace.name }/login"
    browserid_config.logout.path      = "/#{ character_namespace.name }/logout"
  end
end
