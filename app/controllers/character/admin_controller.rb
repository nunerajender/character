# Author: Alexander Kravets
#         Slate, 2013

class Character::AdminController < ActionController::Base
  include NamespaceHelper

  layout false

  before_filter :authenticate_admin_user

  def authenticate_admin_user
    if Rails.env.development? and Character.no_auth_on_development
      @admin_user = current_namespace.user_class.first
    else
      # FIXME: There might be issues during concurrent requests,
      #        find better solution

      Rails.configuration.browserid.user_model       = current_namespace.user_model
      Rails.configuration.browserid.session_variable = "#{current_namespace.name}_browserid_email"
      Rails.configuration.browserid.login.text       = 'Sign-in with Persona'
      Rails.configuration.browserid.login.path       = "/#{current_namespace.name}/login"
      Rails.configuration.browserid.logout.path      = "/#{current_namespace.name}/logout"

      @admin_user = browserid_current_user if browserid_authenticated?
    end
  end

  def login
    respond_to_browserid
  end

  def logout
    logout_browserid
    head :ok
  end
end



