class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)
    fresh_when last_modified: posts_last_updated(@posts), public: true

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:comments, :tags]}))
    fresh_when last_modified: @post.last_changed_at.utc, public: true
    @comment = Comment.new
  end

  private

  def posts_last_updated(posts)
    (
      [Comment.where(post_id: posts.map(&:id)).maximum(:updated_at)] +
      posts.map(&:updated_at)
    ).max
  end
end
