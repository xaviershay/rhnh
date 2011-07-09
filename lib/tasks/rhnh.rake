namespace :rhnh do
  desc "Delete all spam comments in a memory efficient manner"
  task :delete_spam_comments => :environment do
    while !(comments = Comment.find(:all, :limit => 50, :conditions => {:spam => true})).empty?
      comments.each(&:destroy)
    end
  end

  desc "Show each post with its related posts, for testing."
  task :related => :environment do
    Post.find(:all, :include => :tags).each do |post|
      puts post.title
      related = post.related_posts
      puts related.first(3).collect {|post| post.title }.inspect
    end
  end
end
