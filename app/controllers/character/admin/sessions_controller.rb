class Character::Admin::SessionsController < ActionController::Base
  # - this is support for the BrowserID javascript frontend login method
  # TODO: should be revised and probably updated after switch to devise.

  # POST /login
  def create
    # respond_to_browserid
  end

  # POST /logout
  def destroy
    # logout_browserid
    head :ok
  end
end