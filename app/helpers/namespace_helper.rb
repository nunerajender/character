module NamespaceHelper

  def current_namespace
    @current_namespace ||= begin
      name = (/\/([^\/&]+)/.match request.path)[1]
      Character.namespaces[name]
    end
  end

end
