class CommentActivity
  attr_accessor :post

  def initialize(post)
    self.post = post
  end

  def comments
    @comments ||= post.approved_comments(:order => 'created_at DESC', :limit => 5)
  end

  def most_recent_comment
    comments.first
  end

  class << self
    def find_recent
      Post.find(:all, {
        :select => 'distinct posts.*, comments.created_at',
        :joins  => 'INNER JOIN comments ON comments.post_id = posts.id',
        :order  => 'comments.created_at DESC',
        :limit  => 5
      }.merge(Comment.spam_conditions(false))).collect {|post|
        CommentActivity.new(post)
      }
    end
  end
end
