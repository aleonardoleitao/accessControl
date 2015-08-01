class RankingJob
  @queue = 'ranking'

  def self.perform
    Post.find_each(batch_size: 500) do |post|
      post.update_ranking
    end
  end

end
