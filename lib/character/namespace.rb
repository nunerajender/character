module Character
  class Namespace
    @title                  = 'Character'
    @company_logo_image     = 'character-company-logo.png'
    @login_background_image = 'http://images.nationalgeographic.com/exposure/core_media/ngphoto/image/68263_0_1040x660.jpg'
    @no_auth_on_development = false


    attr_accessor :title,
                  :company_logo_image,
                  :login_background_image,
                  :no_auth_on_development
  end
end