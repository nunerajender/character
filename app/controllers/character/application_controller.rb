# Author: Alexander Kravets
#         Slate, 2013

class Character::ApplicationController < Character::BaseController
  include NamespaceHelper

  layout false

  # Filters ===============================================

  before_filter :authenticate_admin_user

  def authenticate_admin_user
    if Rails.env.development? and character_namespace.no_auth_on_development
      @admin_user = character_namespace.user_class.first
    else
      # FIXME: There might be issues during concurrent requests,
      #        find better solution

      browserid_config = Rails.configuration.browserid
      browserid_config.user_model       = character_namespace.user_model
      browserid_config.session_variable = "#{ character_namespace.name }_browserid_email"
      browserid_config.login.text       = 'Sign-in with Persona'
      browserid_config.login.path       = "/#{ character_namespace.name }/login"
      browserid_config.logout.path      = "/#{ character_namespace.name }/logout"

      @admin_user = browserid_current_user if browserid_authenticated?
    end
  end

  # Actions ===============================================

  def index
    render 'character/application'
  end

  def login
    respond_to_browserid
  end

  def logout
    logout_browserid
    head :ok
  end
end



