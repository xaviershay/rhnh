class Comment < ActiveRecord::Base
  acts_as_defensio_comment :fields => { :content => :body, :article => :post }
    
  attr_accessor :openid_error
  attr_accessor :openid_valid

  belongs_to :post

  before_save   :apply_filter

  after_save    :denormalize
  after_destroy :denormalize

  validates_presence_of :author
  validates_presence_of :body

  validates_presence_of :post

  # validate :open_id_thing
  def validate
    super 
    errors.add(:base, openid_error) unless openid_error.blank?
  end

  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(
      self.body,
      :code_formatter => Lesstile::CodeRayFormatter
    )
  end
  
  def blank_openid_fields
    self.author_openid_authority = ""
    self.author_url = ""
    self.author_email = ""
  end

  def requires_openid_authentication?
    !!self.author.index(".")
  end

  def trusted_user?
    false
  end

  def user_logged_in?
    false
  end

  def approved?
    true
  end
 
  def denormalize
    self.post.denormalize_comments_count!
  end

  # Delegates
  def post_title
    post.title
  end

  class << self
    def spam_conditions(spam = true)
      {:conditions => ['comments.spam = ?', spam]}
    end

    def find_spam(args = {})
      find(:all, spam_conditions.merge(args))
    end

    def count_spam
      count(:all, spam_conditions)
    end

    def build_for_preview(params)
      comment = Comment.new(params)
      comment.created_at = Time.now
      comment.apply_filter

      if comment.requires_openid_authentication?
        comment.author_url = comment.author
        comment.author = "Your OpenID Name"
      end
      comment
    end

    def protected_attribute?(attribute)
      [:author, :body].include?(attribute.to_sym)
    end
  end
end
