module CommentHelper
  # Generate resource show path. e.g. exercise_path(@exercise)
  def comment_source_path comment
    self.send("#{comment.commentable.class.name.underscore}_path", comment.commentable)
  end
end
