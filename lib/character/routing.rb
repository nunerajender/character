module ActionDispatch::Routing
  class Mapper

    def mount_character
      Character.namespaces.each do |name, settings|

        scope "/#{name}", :module => "Character" do

          match '/',        to: 'application#index'
          match '/login',   to: 'application#login'
          match '/logout',  to: 'application#logout'

          # Register redactor images if module is defined
          # -------------------------------------------------
          # I don't really like that this is hardcoded here. It would be nice
          # to have module option to add it's routes to the /admin scope.
          if defined?(Character::Redactor)
            scope '/redactor', :module => "Redactor" do
              resources :images, only: [:index, :create]
            end
          end

          get     '/settings/:scope(.:format)',     to: 'settings#show'
          post    '/settings/update',               to: 'settings#update'

          get     '/:model_slug(.:format)',         to: 'api#index'
          get     '/:model_slug/new(.:format)',     to: 'api#new'
          post    '/:model_slug(.:format)',         to: 'api#create'
          get     '/:model_slug/:id(.:format)',     to: 'api#show'
          get     '/:model_slug/:id/edit(.:format)',to: 'api#edit'
          put     '/:model_slug/:id(.:format)',     to: 'api#update'
          delete  '/:model_slug/:id(.:format)',     to: 'api#destroy'
        end
      end
    end
  end
end