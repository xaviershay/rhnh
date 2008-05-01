require File.dirname(__FILE__) + '/../spec_helper'

describe DeleteCommentsUndo do
  def comments_data
    [{'id' => 1, 'a' => 'b'},
     {'id' => 2, 'a' => 'c'}].to_yaml
  end

  describe '#process!' do
    it 'creates new comments based on the attributes array stored in #data' do
      Comment.stub!(:find_by_id).and_return(nil)
      
      item = DeleteCommentsUndo.new(:data => comments_data)
      item.stub!(:transaction).and_yield
      item.stub!(:destroy)

      Comment.should_receive(:create).with('a' => 'b').and_return(mock("comment", :new_record? => false))
      Comment.should_receive(:create).with('a' => 'c').and_return(mock("comment", :new_record? => false))
      item.process!
    end
  end

  describe '#process! with existing comment' do
    it 'raises' do
      pending("figure out why should_raise doesn't work")
      Comment.stub!(:find_by_id).and_return(Object.new)
      lambda { DeleteCommentsUndo.new(:data => comments_data).process! }.should_raise(UndoFailed)
    end
  end

  describe '#process! with invalid comment' do
    it 'raises' do
      pending("figure out why should_raise doesn't work")
      Comment.stub!(:find_by_id).and_return(nil)

      Comment.should_receive(:create).with('a' => 'b').and_return(mock("comment", :new_record? => true))
      lambda { DeleteCommentsUndo.new(:data => comments_data).process! }.should_raise(UndoFailed)
    end
  end

  describe '#description' do
    it("should not be nil") { DeleteCommentsUndo.new(:data => comments_data).description.should_not be_nil }
  end

  describe '#complete_description' do
    it("should not be nil") { DeleteCommentsUndo.new(:data => comments_data).complete_description.should_not be_nil }
  end

  describe '.create_undo' do
    it "creates a new undo item based on the attributes of the given comment" do
      comments = [Comment.new(:author => 'Don Alias'), Comment.new(:author => 'Don Alias')]
      DeleteCommentsUndo.should_receive(:create!).with(:data => comments.collect(&:attributes).to_yaml).and_return(obj = Object.new)
      DeleteCommentsUndo.create_undo(comments).should == obj
    end
  end
end
