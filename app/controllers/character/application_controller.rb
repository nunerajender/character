# Author: Alexander Kravets
#         Slate, 2013

class Character::ApplicationController < ActionController::Base
  include Character::InstanceConcern
  include Character::AuthConcern

  before_filter :authenticate_user

  layout false

  def index
    render 'character/character'
  end

  def login
    respond_to_browserid
  end

  def logout
    logout_browserid

    if params['redirect']
      redirect_to params['redirect']
    else
      head :ok
    end
  end

  private

  def authenticate_user
    if not auto_login!
      if browserid_authenticated? then login! else register_first_user! end
    end
  end
end