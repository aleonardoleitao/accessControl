class TwitterJob
  @queue = 'twitter'

  def self.perform(post_id)
    post = Post.find(post_id)
    client = TwitterOAuth::Client.new(
      consumer_key: 'XGTp7klLUkpp02gRKkZ5L1Jt0',
      consumer_secret: 'jisc6wCj3KQdVSz3JLZUJjbfsWvDpib9kKGq1swjwpsMlRSfXi',
      token: post.profile.user.access_token,
      secret: post.profile.user.access_token_secret
    )
    url = Rails.application.routes.url_helpers.profile_post_path(post.profile.username, post, anchor: 'profile-posts')

    client.update("Postei uma foto no OpenCRS: http://opencrs.com#{url}")
  end
end
