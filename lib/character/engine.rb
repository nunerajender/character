module Character
  class Engine < ::Rails::Engine
    config.before_configuration do
      config.browserid.user_model   = "Character::AdminUser"
      config.browserid.login.text   = 'Sign-in with Persona'
      config.browserid.login.path   = '/admin/login'
      config.browserid.logout.path  = '/admin/logout'
    end
  end
end