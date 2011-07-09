class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)
    if stale?(last_modified: posts_last_updated(@posts))
      respond_to do |format|
        format.html
        format.atom { render :layout => false }
      end
    end
  end

  def show
    @post = Post.find_by_permalink(
      *([:year, :month, :day, :slug].collect {|x|
        params[x]
      } << {:include => [:comments, :tags]})
    )
    if stale?(last_modified: @post.last_changed_at.utc)
      @comment = Comment.new
    end
  end

  private

  def posts_last_updated(posts)
    (
      [Comment.where(post_id: posts.map(&:id)).maximum(:updated_at)].compact +
      posts.map(&:updated_at)
    ).max
  end
end
