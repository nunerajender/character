# Author: Alexander Kravets
#         Slate, 2013

class Character::AdminController < ActionController::Base
  layout false

  before_filter :authenticate_admin_user

  def authenticate_admin_user
    @admin_user = browserid_current_user if browserid_authenticated?
  end

  def login
    respond_to_browserid
  end

  def logout
    logout_browserid
    head :ok
  end  
end



