# Author: Alexander Kravets
#         Slate, 2013

class Character::ApplicationController < Character::BaseController
  include InstanceHelper

  layout false

  def authenticate_user
    if browserid_authenticated?
      @current_user = browserid_current_user
    else
      @browserid_email = browserid_email

      # if no users and this is first time login create an account to logged in user
      if not character_instance.user_class.first
        @current_user = character_instance.user_class.create(email: @browserid_email) if @browserid_email
      end
    end
  end

  def index
    render 'character/application'
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
end