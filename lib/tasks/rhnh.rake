namespace :rhnh do
  desc "Delete all spam comments in a memory efficient manner"
  task :delete_spam_comments => :environment do
    while !(comments = Comment.find(:all, :limit => 50, :conditions => {:spam => true})).empty?
      comments.each(&:destroy)
    end
  end
end
