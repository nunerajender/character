require 'rails/generators'

module Character
  # module Rails
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "This generator adds character admin assets and routes to the new project."
        source_root File.expand_path("../../templates", __FILE__)

        def copy_initializer_file
          copy_file "initializer.rb", "config/initializers/character.rb"
        end

        def copy_settings_file
          copy_file "settings.yml", "config/settings.yml"
        end

        def copy_assets
          copy_file "admin.coffee", "app/assets/javascripts/admin.coffee"
          copy_file "admin.scss", "app/assets/stylesheets/admin.scss"
        end

        def add_routes
          inject_into_file "config/routes.rb", before: "  # The priority is based upon order of creation:\n" do <<-'RUBY'
  mount_character()
          RUBY
          end
        end

        def remove_assets_require_tree
          gsub_file 'app/assets/javascripts/application.js', "//= require_tree .\n", ''
          gsub_file 'app/assets/stylesheets/application.css', " *= require_tree .\n", ''
        end

        def add_production_configuration
          application(nil, env: "production") do
            "config.assets.precompile += %w( admin.js admin.css vendor/modernizr.js foundation.js )"
          end
        end
      end
    end
  # end
end