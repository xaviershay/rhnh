require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CommentsController do
  describe "route generation" do
    it "maps mark_as_ham" do
      route_for(:controller => "admin/comments", :action => "mark_as_ham", :id => 1).should == "/admin/comments/1/mark_as_ham"
    end

    it "maps mark_as_spam" do
      route_for(:controller => "admin/comments", :action => "mark_as_spam", :id => 1).should == "/admin/comments/1/mark_as_spam"
    end

    it "maps spam" do
      route_for(:controller => "admin/comments", :action => "spam").should == "/admin/comments/spam"
    end
  end

  describe "route recognition" do
   it 'generates mark_as_ham params' do
    params_from(:post, '/admin/comments/1/mark_as_ham').should == {:controller => 'admin/comments', :action => 'mark_as_ham', :id => '1'}
   end

   it 'generates mark_as_spam params' do
    params_from(:post, '/admin/comments/1/mark_as_spam').should == {:controller => 'admin/comments', :action => 'mark_as_spam', :id => '1'}
   end

   it 'generates spam params' do
    params_from(:delete, '/admin/comments/spam').should == {:controller => 'admin/comments', :action => 'spam'}
   end
  end
end
