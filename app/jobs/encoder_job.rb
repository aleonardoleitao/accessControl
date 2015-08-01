class EncoderJob
  @queue = 'encoding'

  def self.perform(post_id)
    post = Post.find(post_id)
    encoder = Encoder.new(post.media.path)
    output_filename = encoder.perform
    post.update_attribute(:encoded_video, output_filename)
  end
end
