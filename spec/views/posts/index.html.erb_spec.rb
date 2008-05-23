require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.html.erb" do
  before(:each) do
    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_post = mock_model(Post,
      :title                   => "A post",
      :body_html               => "Posts contents!",
      :published_at            => 1.year.ago,
      :slug                    => 'a-post',
      :approved_comments_count => 1,
      :tags                    => [mock_tag]
    )

    assigns[:posts] = [mock_post, mock_post]
  end

  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it "should render list of posts" do
    render "/posts/index.html.erb"
  end

  it "should render list of posts with a tag" do
    assigns[:tag] = 'code'
    render "/posts/index.html.erb"
  end
end
