namespace :sphinx do
  task :related => :environment do
    Post.find(:all, :include => :tags).each do |post|
      puts post.title
      related = Post.search(:conditions => {:tag_list => post.tag_list.join("|")}).reject {|x| x == post }
      #related = Post.search(post.tag_list.join("|")).reject {|x| x == post }
      puts related.first(3).collect {|post| post.title }.inspect
    end
  end
end
