class MessagesJob
  @queue = 'messages'

  def self.perform
    Message.clean_up
  end

end
