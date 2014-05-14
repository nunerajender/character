xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:dc" => "http://purl.org/dc/elements/1.1/", :version => "2.0" do
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
        xml.guid 'http://' + @domain + posts_show_path(post.id.to_s)
        xml.category post.category.title if post.category
      end
    end
  end
end