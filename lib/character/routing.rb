module ActionDispatch::Routing
  class Mapper

    def mount_character_admin

      # TODO: Max, please move this into /admin scope
      devise_for :admin_users, :class_name => "Character::AdminUser"

      scope '/admin', :module => "Character" do
        
        match '/', to: 'admin#admin'

        get     '/:model_slug(.:format)',         to: 'admin#index'
        get     '/:model_slug/new(.:format)',     to: 'admin#new'
        post    '/:model_slug(.:format)',         to: 'admin#create'
        get     '/:model_slug/:id(.:format)',     to: 'admin#show'
        get     '/:model_slug/:id/edit(.:format)',to: 'admin#edit'
        put     '/:model_slug/:id(.:format)',     to: 'admin#update'
        delete  '/:model_slug/:id(.:format)',     to: 'admin#destroy'
        
        # TODO: this should be replaced with extended update API functionality
        #post    '/:model_slug/reorder(.:format)', to: 'admin#reorder'
      end
    end
  end
end