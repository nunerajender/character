# Author: Alexander Kravets
#         Slate, 2013

class Character::BaseController < ActionController::Base
  include NamespaceHelper

  layout false

  before_filter :authenticate_admin_user

  def authenticate_admin_user
    @admin_user = browserid_current_user if browserid_authenticated?

    unless browserid_authenticated?
      if Rails.env.development? and Character.no_auth_on_development
        @admin_user = current_namespace.user_class.first
      else
        render status: :unauthorized, json: { error: "Access denied." }
      end
    end
  end

end
