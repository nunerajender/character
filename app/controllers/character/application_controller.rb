# Author: Alexander Kravets
#         Slate, 2013

class Character::ApplicationController < Character::BaseController
  include NamespaceHelper

  layout false

  # Filters ===============================================

  # Filter already defined in BaseController
  # before_filter :authenticate_user

  def authenticate_user
    if (Rails.env.development? and character_namespace.no_auth_on_development) or Rails.env.test?
      authenticate_first_user
    else
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



