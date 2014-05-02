module CharacterHelper
  def page_templates()
    app_pages_templates = Dir.glob('app/views/pages/_*.html.erb').collect do |t|
      t.split('/_').last.gsub('.html.erb', '')
    end
    app_pages_templates + %w( redactor default )
  end
end