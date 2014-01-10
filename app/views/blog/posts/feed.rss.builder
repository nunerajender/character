xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @blog_title
    xml.description @blog_description
    xml.link 'http://' + @blog_domain + blog_index_path

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.tagline
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link 'http://' + @blog_domain + blog_post_path(post)
        xml.guid 'http://' + @blog_domain + blog_post_path(post)
      end
    end
  end
end