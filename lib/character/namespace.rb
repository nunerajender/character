module Character
  class Namespace
    DEFAULT_NAMESPACE = "admin"

    attr_accessor :name,
                  :title,
                  :user_model,

                  :company_logo_image,
                  :login_background_image,
                  :no_auth_on_development


    def initialize(name = Namespace::DEFAULT_NAMESPACE)
      @name                   = name
      @title                  = 'Character'
      @user_model             = 'Character::AdminUser'
      @company_logo_image     = 'character-company-logo.png'
      @login_background_image = 'http://images.nationalgeographic.com/exposure/core_media/ngphoto/image/68263_0_1040x660.jpg'
      @no_auth_on_development = false
    end


    def user_class
      @user_class ||= @user_model.constantize
    end


    def default?
      @name == Namespace::DEFAULT_NAMESPACE
    end
  end
end