require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CommentsController do
  describe 'handling GET to index' do
    before(:each) do
      @posts = [mock_model(Comment), mock_model(Comment)]
      Comment.stub!(:paginate).and_return(@comments)
      session[:logged_in] = true
      get :index
    end

    it("is successful")               { response.should be_success }
    it("renders index template")      { response.should render_template('index') }
    it("finds comments for the view") { assigns[:comments].should == @comments }
  end

  describe 'handling GET to show' do
    before(:each) do
      @comment = Comment.new
      Comment.stub!(:find).and_return(@comment)
      session[:logged_in] = true
      get :show, :id => 1
    end

    it("is successful")              { response.should be_success }
    it("renders show template")      { response.should render_template('show') }
    it("finds comment for the view") { assigns[:comment].should == @comment }
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @comment = mock_model(Comment, :author => 'Don Alias')
      @comment.stub!(:update_attributes).and_return(true)
      Comment.stub!(:find).and_return(@comment)

      @attributes = {'body' => 'a comment'}
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :comment => @attributes 
    end

    it("redirects to index") do
      do_put
      response.should be_redirect
      response.should redirect_to(admin_comments_path)
    end

    it("updates comment") do
      @comment.should_receive(:update_attributes).with(@attributes).and_return(true)
      do_put
    end

    it("puts a message in the flash") do
      do_put
      flash[:notice].should_not be_blank 
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @comment = mock_model(Comment, :author => 'Don Alias')
      @comment.stub!(:update_attributes).and_return(false)
      Comment.stub!(:find).and_return(@comment)

      @attributes = {:body => ''}
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :comment => @attributes 
    end

    it("renders show") do
      do_put
      response.should render_template('show')
    end

    it("assigns comment for the view") do
      do_put
      assigns(:comment).should == @comment
    end
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      @comment = Comment.new
      @comment.stub!(:destroy)
      Comment.stub!(:find).and_return(@comment)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1
    end

    it("redirects to index") do
      do_delete
      response.should be_redirect
      response.should redirect_to(admin_comments_path)
    end

    it("deletes comment") do
      @comment.should_receive(:destroy)
      do_delete
    end
  end

  describe 'handling DELETE to destroy, JSON request' do
    before(:each) do
      @comment = Comment.new(:author => 'xavier')
      @comment.stub!(:destroy_with_undo).and_return(mock("undo_item", :description => 'hello'))
      Comment.stub!(:find).and_return(@comment)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1, :format => 'json'
    end

    it("deletes comment") do
      @comment.should_receive(:destroy_with_undo).and_return(mock("undo_item", :description => 'hello'))
      do_delete
    end

    it("renders comment as json") do
      do_delete
      response.should have_text(/#{Regexp.escape(@comment.to_json)}/)
    end
  end

  describe 'handling POST to mark_as_spam' do
    before(:each) do
      @comment = Comment.new
      @comment.stub!(:report_as_spam)
      Comment.stub!(:find).and_return(@comment)
    end

    def do_post
      request.env['HTTP_REFERER'] = '/bogus'
      session[:logged_in] = true
      post :mark_as_spam, :id => '6'
    end

    it 'finds comment by id' do
      Comment.should_receive(:find).with('6').and_return(@comment)
      do_post
    end

    it 'marks comment as spam' do
      @comment.should_receive(:send_later).with(:report_as_spam)
      do_post
    end

    it 'redirects back' do
      do_post
      response.should be_redirect
      response.should redirect_to("/bogus")
    end
  end

  describe 'handling POST to mark_as_ham' do
    before(:each) do
      @comment = Comment.new
      @comment.stub!(:report_as_ham)
      Comment.stub!(:find).and_return(@comment)
    end

    def do_post
      request.env['HTTP_REFERER'] = '/bogus'
      session[:logged_in] = true
      post :mark_as_ham, :id => '6'
    end

    it 'finds comment by id' do
      Comment.should_receive(:find).with('6').and_return(@comment)
      do_post
    end

    it 'marks comment as ham' do
      @comment.should_receive(:send_later).with(:report_as_ham)
      do_post
    end

    it 'redirects back' do
      do_post
      response.should be_redirect
      response.should redirect_to("/bogus")
    end
  end

  describe 'handling DELETE to spam' do
    before(:each) do
      @comments = [mock_model(Comment), mock_model(Comment)]
      @comments.each do |comment|
        comment.stub!(:destroy)
      end
      Comment.stub!(:find_spam).and_return(@comments)
    end

    def do_delete
      request.env['HTTP_REFERER'] = '/bogus'
      session[:logged_in] = true
      delete :spam
    end

    it 'destroys each spam comment' do
      @comments.each do |comment|
        comment.should_receive(:destroy)
      end
      do_delete
    end

    it 'redirects back' do
      do_delete
      response.should be_redirect
      response.should redirect_to("/bogus")
    end
  end
end
