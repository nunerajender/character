module InstanceHelper

  def character_instance
    @character_instance ||= begin
      name = (/\/([^\/&]+)/.match request.path)[1]
      Character.instances[name]
    end
  end

end
