task :migrate_reply_to_comment => :environment do
  Topic.find_each do |topic|
    topic.replies.each do |reply|
      comment = Comment.new(commentable: topic, content: reply.content)
      comment.author = reply.author
      comment.created_at = reply.created_at
      comment.updated_at = reply.updated_at
      comment.save!
    end
  end
end
