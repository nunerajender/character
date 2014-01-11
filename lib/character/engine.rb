module Character
  class << self
    attr_writer :instances

    def instances
      if @instances.blank?
        @instances = { Instance::DEFAULT_NAME => Instance.new }
      else
        @instances
      end
    end

    def configure(&block)
      block.call(self)
    end

    def instance(name, &block)
      @custom_instance_name_used = true
      raise StandardError.new("Please don't mix character instance configuration & default character configuration.") if @default_instance_name_used

      block.call( @instances[name] ||= Instance.new(name) )
    end

    def method_missing(method, *args)
      @default_instance_name_used = true
      raise StandardError.new("Please don't mix character instance configuration & default character configuration.") if @custom_instance_name_used

      ( @instances[Instance::DEFAULT_NAME] ||= Instance.new ).send method, *args
    end
  end

  class Engine < ::Rails::Engine
    config.before_configuration do
      Character.instances = {}
      config.autoload_paths += %W( #{config.root}/app/controllers/character/concerns )
    end
  end
end
