xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.description @description
    xml.link 'http://' + @domain + posts_index_path

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.subtitle
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link 'http://' + @domain + posts_show_path(post)
        xml.guid 'http://' + @domain + post_show_path(post)
      end
    end
  end
end