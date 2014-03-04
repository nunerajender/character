require 'rails/generators'

module Character
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Setup posts, pages and admin."
      source_root File.expand_path("../../templates", __FILE__)

      def override_layout
        copy_file 'application.html.erb', 'app/views/layouts/application.html.erb'
      end

      def copy_initializer_file
        copy_file "initializer.rb", "config/initializers/character.rb"
      end

      def copy_settings_file
        copy_file "settings.yml", "config/settings.yml"
      end

      def setup_assets
        copy_file "admin.coffee", "app/assets/javascripts/admin.coffee"
        copy_file "admin.scss", "app/assets/stylesheets/admin.scss"

        insert_into_file  "app/assets/stylesheets/application.css",
                          " *= require application/default\n",
                          :after => " *= require_self\n"
      end

      def add_routes
        inject_into_file "config/routes.rb", before: "  # The priority is based upon order of creation: first created -> highest priority.\n" do <<-'RUBY'
mount_character_instance 'admin'
mount_posts_at '/'
mount_pages_at '/'
RUBY
        end
      end

      def remove_assets_require_tree
        gsub_file 'app/assets/javascripts/application.js', "//= require_tree .\n", ''
        gsub_file 'app/assets/stylesheets/application.css', " *= require_tree .\n", ''
      end

      def add_production_configuration
        application(nil, env: "production") do
          "config.assets.precompile += %w( admin.js admin.css )"
        end
      end
    end
  end
end