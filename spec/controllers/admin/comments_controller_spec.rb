require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CommentsController do
  describe 'handling GET to index' do
    before(:each) do
      @comments = [mock_model(Comment), mock_model(Comment)]
      Comment.stub!(:paginate).and_return(@comments)
      session[:logged_in] = true

      get :index
    end

    it "is successful" do
      response.should be_success
    end

    it "renders index template" do
      response.should render_template('index')
    end

    it "finds comments for the view" do
      assigns[:comments].should == @comments
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
      @comment.should_receive(:report_as_spam)
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
      @comment.should_receive(:report_as_ham)
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
