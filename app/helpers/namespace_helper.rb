module NamespaceHelper

  def character_namespace
    @character_namespace ||= begin
      name = (/\/([^\/&]+)/.match request.path)[1]
      Character.namespaces[name]
    end
  end

end
