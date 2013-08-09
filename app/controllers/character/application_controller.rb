# Author: Alexander Kravets
#         Slate, 2013

class Character::ApplicationController < Character::BaseController
  include NamespaceHelper

  layout false

  before_filter :authenticate_admin_user

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



