require File.dirname(__FILE__) + '/../../spec_helper'

describe "/search/show.html.erb" do
  describe 'with search results' do
    before(:each) do
      mock_post = mock_model(Post,
        :title                   => "A post",
        :body_html               => "Posts contents!",
        :published_at            => 1.year.ago,
        :slug                    => 'a-post',
        :approved_comments_count => 1,
        :tags                    => []
      )

      assigns[:posts] = [mock_post, mock_post]
      assigns[:search_term] = "hello"
    end

    after(:each) do
      response.should be_valid_xhtml_fragment
    end

    it "should render list of posts" do
      render "/search/show.html.erb"
    end
  end

  describe 'with no search results' do
    before(:each) do
      assigns[:posts] = []
      assigns[:search_term] = "hello"
    end

    after(:each) do
      response.should be_valid_xhtml_fragment
    end

    it "should render list of posts" do
      render "/search/show.html.erb"
    end
  end
end
