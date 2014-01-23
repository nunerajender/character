require 'rails/generators'

module Character
  module Blog
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "This generator adds character blog assets and routes to the new project."
        source_root File.join(File.dirname(__FILE__), '..', 'templates')

        def add_assets
          # Default blog CSS theme
          remove_file 'app/assets/stylesheets/application.css'
          copy_file 'application.scss', 'app/assets/stylesheets/application.scss'

          # Character JS
          insert_into_file  "app/assets/javascripts/admin.coffee",
                            "#= require character/plugins/redactor\n",
                            :after => "character\n"

          insert_into_file  "app/assets/javascripts/admin.coffee",
                            "\nchr.blogPosts()\n",
                            :after => "require_self\n"

          # Character CSS
          insert_into_file  "app/assets/stylesheets/admin.scss",
                            "@import \"character/plugins/redactor\";\n",
                            :after => "\"character\";\n"
        end

        def add_routes
          inject_into_file "config/routes.rb", after: "  mount_character_instance('admin')\n" do <<-'RUBY'
  mount_blog_at('/')
RUBY
          end
        end

        def override_layout
          copy_file 'application.html.erb', 'app/views/layouts/application.html.erb'
        end

        def add_settings
          inject_into_file "config/settings.yml", after: "# END" do <<-'RUBY'

# Blog Settings

Blog Settings:
  Domain:
    type: string
    description: Domain of the website where blog lives.
    default_value: www.my-domain.com

  Title:
    type: string
    description: Shown for blog index page in browser title.
    default_value: My Blog Title

  Description:
    type: text
    description: Indexed by Google and is shown in search results.
    default_value: My Blog two-three sentences description. What is this all about.

  Keywords:
    type: text
    description: Split keywords by comma. They are used by Google and other search engines.
    default_value: 'web, blog, internet'

  Disqus Shortname:
    type: text
    description: If defined disqus is used to comment blog posts.
    default_value: ''

# END
RUBY
          end
        end

      end
    end
  end
end