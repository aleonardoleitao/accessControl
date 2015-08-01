class OnlineJob
  @queue = 'online'

  def self.perform
    User.where(online: true).where("last_seen_at < ? OR last_seen_at IS NULL", 70.seconds.ago).update_all(online: false)
  end
end
