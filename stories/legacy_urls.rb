Story "Legacy URLs", %{
  As a user
  I want to be redirected to the correct page when visiting old URLs
  So I can find the information I want
}, :type => RailsStory do
  Scenario "old feed URL" do
    When "visiting mephisto feed URL",  "/feed/atom.xml" do |page|
      get page
    end

    Then "the user is permanently redirected to rhnh enki feed URL", "/posts.atom" do |path|
      response.should redirect_to(path)
    end
  end
end
