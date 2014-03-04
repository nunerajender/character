module ActionDispatch::Routing
  class Mapper
    def mount_character_instance(name='admin')
      scope "/#{ name }", :module => "character" do
        get   '/',       to: 'application#index'
        match '/login',  to: 'application#login',  via: [ :post, :get ]
        match '/logout', to: 'application#logout', via: [ :post, :get ]

        # settings api
        get  '/settings/:template_name(.:format)', to: 'settings#show'
        post '/settings/:template_name(.:format)', to: 'settings#update'

        # generic api
        get    '/:model_slug(.:format)',           to: 'api#index'
        get    '/:model_slug/new(.:format)',       to: 'api#new'
        get    '/:model_slug/:id(.:format)',       to: 'api#show'
        get    '/:model_slug/:id/edit(.:format)',  to: 'api#edit'
        match  '/:model_slug(.:format)',           to: 'api#create', via: [ :post, :put, :patch ]
        post   '/:model_slug/:id(.:format)',       to: 'api#update'
        patch  '/:model_slug/:id(.:format)',       to: 'api#patch'
        delete '/:model_slug/:id(.:format)',       to: 'api#destroy'
      end
    end

    def mount_posts_at(mount_location)
      scope mount_location do
        get '/'               => 'posts#index',    as: :posts_index
        get '/c/:slug'        => 'posts#category', as: :posts_category
        get '/p/:slug'        => 'posts#show',     as: :posts_show
        get '/feed(.:format)' => 'posts#feed',     as: :posts_feed
      end
    end

    def mount_pages_at(mount_location)
      scope mount_location do
        get '/:path' => 'pages#show', as: :pages_show
      end
    end
  end
end