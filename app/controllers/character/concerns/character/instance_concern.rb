module Character::InstanceConcern
  extend ActiveSupport::Concern

  def character_instance
    @character_instance ||= begin
      name = (/\/([^\/&]+)/.match request.path)[1]
      Character.instances[name]
    end
  end

  def browserid_config
    @browserid_config ||= begin
      config = Rails.configuration.browserid.clone
      config.user_model       = character_instance.user_model
      config.session_variable = "#{ character_instance.name }_browserid_email"
      config.login.text       = 'Sign-in with Persona'
      config.login.path       = "/#{ character_instance.name }/login"
      config.logout.path      = "/#{ character_instance.name }/logout"
      config
    end
  end
end
