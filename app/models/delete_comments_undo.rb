class DeleteCommentsUndo < UndoItem
  def process!
    transaction do
      self.destroy
      loaded_data.collect do |attributes|
        raise(UndoFailed) if Comment.find_by_id(attributes.delete('id').to_i)

        comment = Comment.create(attributes.merge(:human_test => Comment::HUMAN_ANSWER))
        raise UndoFailed if comment.new_record?
        comment
      end
    end
  end

  def description
    count = loaded_data.size
    "Deleted " + pluralized_comment_description
  end

  def complete_description
    "Recreated " + pluralized_comment_description
  end

  class << self
    def create_undo(comments)
      DeleteCommentsUndo.create!(:data => comments.collect(&:attributes).to_yaml)
    end
  end

  private

  def comments_count
    count = loaded_data.size
  end

  def pluralized_comment_description
    "#{comments_count} comment#{comments_count == 1 ? "" : "s"}"
  end
end
