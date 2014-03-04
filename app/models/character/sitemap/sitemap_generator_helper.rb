class Character::Sitemap::SitemapGeneratorHelper
  def self.add_links(sitemap)
    url_helpers = Rails.application.routes.url_helpers
    url = "http://#{ @domain }"

    sitemap.add "#{ url }#{ url_helpers.posts_index_path }",
      changefreq: "daily"

    Character::Post.published.each do |post|
      sitemap.add "#{ url }#{ url_helpers.posts_show_path(post) }",
        changefreq: "weekly",
        lastmod: post.updated_at
    end
  end
end