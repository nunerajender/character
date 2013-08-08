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
      block.call( @namespaces[name] ||= Namespace.new(name) )
    end

    def method_missing(method, *args)
      ( @namespaces[Namespace::DEFAULT_NAMESPACE] ||= Namespace.new ).send method, *args
    end
  end
end
