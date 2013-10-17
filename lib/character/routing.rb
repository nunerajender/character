module ActionDispatch::Routing
  class Mapper

    def mount_character
      Character.namespaces.each do |name, settings|

        scope "/#{name}", :module => "character" do

          match '/',        to: 'application#index'
          match '/login',   to: 'application#login'
          match '/logout',  to: 'application#logout'

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