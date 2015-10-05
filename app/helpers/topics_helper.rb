module TopicsHelper
  def is_own_topic? topic
    current_user && current_user.topics.include?(topic)
  end
end
