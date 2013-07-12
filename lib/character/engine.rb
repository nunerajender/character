module Character
  class Engine < ::Rails::Engine
    config.before_configuration do
      config.browserid.user_model        = "Character::AdminUser"
      config.browserid.login.text        = 'Sign-in with Persona'
      config.browserid.login.path        = '/admin/login'
      config.browserid.logout.path       = '/admin/logout'

      Character.title                  = 'Character'
      Character.company_logo_image     = 'character-company-logo.png'
      Character.login_background_image = 'http://images.nationalgeographic.com/exposure/core_media/ngphoto/image/68263_0_1040x660.jpg'
    end
  end

  class << self
    attr_accessor :title
    attr_accessor :company_logo_image
    attr_accessor :login_background_image

    def configure(&block)
      block.call(self)
    end
  end
end