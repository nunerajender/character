module Character
  class Engine < ::Rails::Engine
    config.before_configuration do
      Character.namespaces = {}
    end
  end

  class << self
    attr_writer :namespaces

    def namespaces
      if @namespaces.blank?
        @namespaces = { Namespace::DEFAULT_NAMESPACE => Namespace.new }
      else
        @namespaces
      end
    end

    def configure(&block)
      block.call(self)
    end

    def namespace(name, &block)
      @custom_namespace_used = true
      raise StandardError.new("Please do not mix namespaced & default configurations") if @default_namespace_used

      block.call( @namespaces[name] ||= Namespace.new(name) )
    end

    def method_missing(method, *args)
      @default_namespace_used = true
      raise StandardError.new("Please do not mix namespaced & default configurations") if @custom_namespace_used

      ( @namespaces[Namespace::DEFAULT_NAMESPACE] ||= Namespace.new ).send method, *args
    end
  end
end
