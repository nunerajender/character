module Character
  class Engine < ::Rails::Engine
    config.before_configuration do
      config.browserid.user_model        = "Character::AdminUser"
      config.browserid.login.text        = 'Sign-in with Persona'
      config.browserid.login.path        = '/admin/login'
      config.browserid.logout.path       = '/admin/logout'

      Character.title              = 'Character'
      Character.company_logo_image = ''
    end
  end

  class << self
    attr_accessor :title
    attr_accessor :company_logo_image

    def configure(&block)
      block.call(self)
    end
  end
end