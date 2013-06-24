class Character::Admin::BaseController < ActionController::Base
  
  # TODO: revise when switch to devise
  before_filter :authenticate_admin_user
  # - this auth method should be revised when switch to devise

  def authenticate_admin_user
    @character_admin_user = browserid_current_user if browserid_authenticated?
    @character_admin_user = Character::AdminUser.first
  end

end