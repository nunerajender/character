# Author: Alexander Kravets
#         Slate, 2013

class Character::AuthController < ActionController::Base
  def login
    respond_to_browserid
  end

  def logout
    logout_browserid
    head :ok
  end
end