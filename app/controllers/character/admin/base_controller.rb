class Character::Admin::BaseController < ActionController::Base
  before_filter :authenticate_admin_user!

  # def authenticate_admin_user
  #   @character_admin_user = browserid_current_user if browserid_authenticated?
  #   @character_admin_user = Character::AdminUser.first
  # end
end