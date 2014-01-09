require 'rails/generators'

module Character
  module Blog
    # module Rails
      module Generators
        class InstallGenerator < ::Rails::Generators::Base
          desc "This generator adds character blog assets and routes to the new project."
          #source_root File.expand_path("../../templates", __FILE__)
          source_root File.join(File.dirname(__FILE__), '..', 'templates')

          def add_assets
            # Default blog CSS theme
            remove_file 'app/assets/stylesheets/application.css'
            copy_file 'application.scss', 'app/assets/stylesheets/application.scss'

            # Character JS
            insert_into_file  "app/assets/javascripts/admin.coffee",
                              "#= require character/redactor\n",
                              :after => "character/settings\n"

            insert_into_file  "app/assets/javascripts/admin.coffee",
                              "#= require character/blog\n",
                              :after => "character/settings\n"

            insert_into_file  "app/assets/javascripts/admin.coffee",
                              "\nBlogPosts()\n",
                              :after => "require_self\n"

            # Character CSS
            insert_into_file  "app/assets/stylesheets/admin.scss",
                              "@import \"character/redactor\";\n",
                              :after => "\"character\";\n"

            insert_into_file  "app/assets/stylesheets/admin.scss",
                              "@import \"character/blog\";\n",
                              :after => "\"character\";\n"
          end

          def add_routes
            inject_into_file "config/routes.rb", after: "  mount_character()\n" do <<-'RUBY'
  mount_blog_short_urls_at('/')
  mount_blog_at('/')
            RUBY
            end
          end

          def override_layout
            copy_file 'application.html.erb', 'app/views/layouts/application.html.erb'
          end

        end
      end
    # end
  end
end