class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  acts_as_defensio_article :validate_key => false
  acts_as_taggable
  
  has_many :searchable_tags, :through => :taggings, :source => :tag,  :conditions => "tags.name NOT IN ('Ruby', 'Code', 'Life')"

  include DefensioArticle

  has_many :comments, :dependent => :destroy
  def approved_comments(options = {})
    if options.empty?
      comments.reject {|comment| comment.spam? || comment.spaminess.nil?}
    else
      comments.find(:all, Comment.spam_conditions(false).merge(options))
    end
  end

  before_validation :generate_slug
  before_validation :set_dates
  before_save :apply_filter

  validates_presence_of :title
  validates_presence_of :slug
  validates_presence_of :body

  validate :validate_published_at_natural

  def validate_published_at_natural
    errors.add("published_at_natural", "Unable to parse time") if published_at.nil?
  end

  attr_accessor :minor_edit
  def minor_edit
    @minor_edit ||= "1"
  end

  def minor_edit?
    self.minor_edit == "1"
  end

  attr_accessor :published_at_natural
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, 'now', "%Y-%m-%d %H:%M")
  end

  class << self
    def find_recent(options = {})
      tag = options.delete(:tag)
      options = {
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.now],
        :limit      => DEFAULT_LIMIT
      }.merge(options)
      if tag
        find_tagged_with(tag, options)
      else
        find(:all, options)
      end
    end

    def find_by_permalink(year, month, day, slug, options = {})
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        post = find_all_by_slug(slug, options).detect do |post|
          post.published_at.midnight == day
        end 
      rescue ArgumentError # Invalid time
        post = nil
      end
      post || raise(ActiveRecord::RecordNotFound)
    end

    def find_all_grouped_by_month
      posts = find(
        :all,
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.now]
      )
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end
  end

  def destroy_with_undo
    transaction do
      self.destroy
      return DeletePostUndo.create_undo(self)
    end
  end

  def month
    published_at.beginning_of_month
  end

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    self.published_at = Chronic.parse(self.published_at_natural)
  end

  def denormalize_comments_count!
    Post.update_all(["approved_comments_count = ?", self.approved_comments.length], ["id = ?", self.id])
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end

  # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
  def tag_list=(value)
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end

  define_index do
    indexes title
    indexes body
    indexes searchable_tags(:name), :as => :tag_list

    has tags(:id), :as => :tags
  end
end
