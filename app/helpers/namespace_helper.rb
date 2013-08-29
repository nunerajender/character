module NamespaceHelper

  def character_namespace
    @character_namespace ||= begin
      name = (/\/([^\/&]+)/.match request.path)[1]
      Character.namespaces[name]
    end
  end


  def find_asset(*files)
    files.each do |file|
      return file if Rails.application.assets.find_asset(file)
    end
    raise ArgumentError.new "Cannot find any of: #{files.join(",")}"
  end

end
