require File.dirname(__FILE__) + '/../spec_helper'

describe SearchController do
  describe 'handling GET to show' do
    before(:each) do
      @posts = [mock_model(Post)]
      Post.stub!(:search).and_return(@posts)
    end

    def do_get
      get :show, :q => 'hello'
    end

    it "successfully renders show template" do
      do_get
      response.should be_success
      response.should render_template("show")
    end

    it "assigns found posts for the view" do
      do_get
      assigns[:posts].should == @posts
    end

    it "assigns the search term for the view" do
      do_get
      assigns[:search_term].should == "hello"
    end
  end
end
