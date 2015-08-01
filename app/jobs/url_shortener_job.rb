class UrlShortenerJob
  @queue = 'shorten_url'

  def self.perform(post_id, post_url)
    bitly = Bitly.shorten(post_url, Settings.bitly.username, Settings.bitly.apikey)
    post = Post.find(post_id)
    post.update_attribute(:short_url, bitly.url)
  end
end
