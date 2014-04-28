module NotFound
  extend ActiveSupport::Concern

  included do
    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      redirect = Character::Redirect.where(path: request.path).first
      if redirect
        redirect_to redirect.destination, status: redirect.type
      else
        render 'errors/not_found', status: 404, layout: false
      end
    end
  end
end