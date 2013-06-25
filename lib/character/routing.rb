module ActionDispatch::Routing
  class Mapper

    def mount_character_admin
      scope '/character', :module => "Character::Admin" do
        match '/',        to: 'admin#index'
        # TODO: two below should be replaced with devise auth methods
        match '/login',   to: 'sessions#create'
        match '/logout',  to: 'sessions#destroy'

        scope 'api' do
          get     '/:model_slug(.:format)',         to: 'api#index'
          get     '/:model_slug/new(.:format)',     to: 'api#new'
          post    '/:model_slug(.:format)',         to: 'api#create'
          get     '/:model_slug/:id(.:format)',     to: 'api#show'
          get     '/:model_slug/:id/edit(.:format)',to: 'api#edit'
          put     '/:model_slug/:id(.:format)',     to: 'api#update'
          delete  '/:model_slug/:id(.:format)',     to: 'api#destroy'
          # TODO: this should be replaced with extended update API functionality
          post    '/:model_slug/reorder(.:format)', to: 'api#reorder'
        end
      end
    end
  end
end