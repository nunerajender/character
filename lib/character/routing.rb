module ActionDispatch::Routing
  class Mapper

    def mount_character_admin
      scope '/admin', :module => "Character" do
        
        match '/', to: 'admin#admin'

        match '/login',   to: 'auth#login'
        match '/logout',  to: 'auth#logout'        

        # Register redactor images if module is defined
        # -------------------------------------------------
        # I don't really like that this is hardcoded here. It would be nice
        # to have module option to add it's routes to the /admin scope.
        if defined?(Character::Redactor)
          scope '/redactor', :module => "Redactor" do
            resources :images, only: [:index, :create]
          end
        end

        get     '/:model_slug(.:format)',         to: 'admin#index'
        get     '/:model_slug/new(.:format)',     to: 'admin#new'
        post    '/:model_slug(.:format)',         to: 'admin#create'
        get     '/:model_slug/:id(.:format)',     to: 'admin#show'
        get     '/:model_slug/:id/edit(.:format)',to: 'admin#edit'
        put     '/:model_slug/:id(.:format)',     to: 'admin#update'
        delete  '/:model_slug/:id(.:format)',     to: 'admin#destroy'

      end
    end
  end
end