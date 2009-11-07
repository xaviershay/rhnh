class Admin::CommentsController < Admin::BaseController
  before_filter :find_comment, :except => [:index, :spam]

  def index
    @comments = Comment.paginate(
      :include => "post",
      :order => "comments.created_at DESC",
      :page => params[:page]
    )
  end

  def spam
    undo_item = Comment.destroy_spam_with_undo
    flash[:notice] = undo_item.description
    redirect_to :back
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'comment', :locals => {:comment => @comment} if request.xhr?
      }
    end
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Updated comment by #{@comment.author}"
      redirect_to :action => 'index'
    else
      render :action => 'show'
    end
  end

  def mark_as_spam
    @comment.send_later(:report_as_spam)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => {
        :undo_message => 'Marked comment as spam',
        :comment      => @comment
      }}
    end
  end

  def mark_as_ham
    @comment.send_later(:report_as_ham)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => {
        :undo_message => 'Marked comment as ham',
        :comment      => @comment
      }}
    end
  end

  def destroy
    undo_item = @comment.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted comment by #{@comment.author}"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :comment      => @comment
        }.to_json
      }
    end
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
