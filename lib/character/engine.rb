module Character
  class Engine < ::Rails::Engine
    config.before_configuration do
      require 'devise/setup'
    end
  end
end