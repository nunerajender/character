module ActionDispatch::Routing
  class Mapper
    def mount_character_instance(name='admin')
      scope "/#{ name }", :module => "character" do
        get   '/',       to: 'application#index'
        match '/login',  to: 'application#login',  via: [ :post, :get ]
        match '/logout', to: 'application#logout', via: [ :post, :get ]

        get  '/settings/:template_name(.:format)', to: 'settings#show'
        post '/settings/:template_name(.:format)', to: 'settings#update'

        get    '/:model_slug(.:format)',          to: 'api#index'
        get    '/:model_slug/new(.:format)',      to: 'api#new'
        get    '/:model_slug/:id(.:format)',      to: 'api#show'
        get    '/:model_slug/:id/edit(.:format)', to: 'api#edit'
        match  '/:model_slug(.:format)',          to: 'api#create', via: [ :post, :put, :patch ]
        post   '/:model_slug/:id(.:format)',      to: 'api#update'
        patch  '/:model_slug/:id(.:format)',      to: 'api#patch'
        delete '/:model_slug/:id(.:format)',      to: 'api#destroy'
      end
    end

    def mount_blog_at(mount_location)
      scope mount_location, :module => 'blog' do
        get  '/'                    => 'posts#index',    as: :blog_index
        get  '/posts/:slug'         => 'posts#show',     as: :blog_post
        get  '/feed(.:format)'      => 'posts#feed',     as: :blog_feed
        post '/posts/:slug/comment' => 'posts#comment',  as: :character_blog_comments
        get  '/:category'           => 'posts#index',    as: :blog_category
      end
    end
  end
end