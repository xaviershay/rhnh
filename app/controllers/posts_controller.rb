class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)
    if stale?(last_modified: posts_last_updated(@posts), public: true)
      respond_to do |format|
        format.html
        format.atom { render :layout => false }
      end
    end
  rescue ArgumentError => e
    if e.message =~ /invalid byte sequence/
      head 400
    else
      raise
    end
  end

  def show
    @post = Post.find_by_permalink(
      *([:year, :month, :day, :slug].collect {|x|
        params[x]
      } << {:include => [:comments, :tags]})
    )
    if stale?(last_modified: @post.last_changed_at.utc, public: true)
      @comment = Comment.new
    end
  end

  private

  def posts_last_updated(posts)
    (
      [Comment.where(post_id: posts.map(&:id)).maximum(:updated_at)].compact +
      posts.map(&:updated_at) +
      [EPOCH]
    ).max.utc
  end
end
