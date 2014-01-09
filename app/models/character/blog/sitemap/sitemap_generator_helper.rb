class Character::Blog::Sitemap::SitemapGeneratorHelper
  def self.add_links(sitemap)
    url_helpers = Rails.application.routes.url_helpers

    sitemap.add "http://#{ Character::Blog.domain }#{ url_helpers.blog_index_path }", changefreq: "daily"
    Character::Blog::Post.published.each do |post|
      sitemap.add "http://#{ Character::Blog.domain }#{ url_helpers.blog_post_path(post) }", changefreq: "weekly", lastmod: post.updated_at
    end
  end
end
