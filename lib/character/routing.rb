module ActionDispatch::Routing
  class Mapper
    def mount_character
      Character.instances.each do |name, settings|

        scope "/#{name}", :module => "character" do

          match '/',        to: 'application#index'
          match '/login',   to: 'application#login'
          match '/logout',  to: 'application#logout'

          get     '/settings/:scope(.:format)',      to: 'settings#show'
          post    '/settings/:scope(.:format)',      to: 'settings#update'

          get     '/:model_slug(.:format)',          to: 'api#index'
          get     '/:model_slug/new(.:format)',      to: 'api#new'
          post    '/:model_slug(.:format)',          to: 'api#create'
          get     '/:model_slug/:id(.:format)',      to: 'api#show'
          get     '/:model_slug/:id/edit(.:format)', to: 'api#edit'
          put     '/:model_slug/:id(.:format)',      to: 'api#update'
          delete  '/:model_slug/:id(.:format)',      to: 'api#destroy'
        end
      end
    end

    def mount_blog_short_urls_at(mount_location)
      scope mount_location, :module => "Blog" do
        get '/:num', to: 'posts#get_by_num', as: :blog_post_short_url, :constraints => { :num => /\d/ }
      end
    end

    def mount_blog_at(mount_location)
      scope mount_location, :module => "Blog" do
        get  '/'                    => 'posts#index',    as: :blog_index
        get  '/posts/:slug'         => 'posts#show',     as: :blog_post
        get  '/feed(.:format)'      => 'posts#feed',     as: :blog_feed
        post '/posts/:slug/comment' => 'posts#comment',  as: :character_blog_comments
        get  '/:category'           => 'posts#index',    as: :blog_category
      end
    end
  end
end