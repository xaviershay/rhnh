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

  desc "Fetch production database into development database"
  task :fetch_production_db do
    Bundler.with_clean_env do
      system("heroku pg:backups delete --app rhnh --confirm rhnh $(heroku pg:backups --app rhnh 2> /dev/null | head -n 4 | tail -n 1 | cut -d ' ' -f 1)")
      system("heroku pg:backups capture --app rhnh && curl $(heroku pg:backups public-url --app rhnh) | pg_restore --clean --no-owner -d rhnh_development")
    end
  end

  task :export_posts => :environment do
    Post.find_each do |post|
      filename = "%s-%s.lesstile" % [post.published_at.strftime("%Y-%m-%d"), post.slug]
      dir = "../rhnh-static/_posts"

      puts filename

      body = <<-EOS
---
layout: post
title:  #{post.title.inspect}
date:   #{post.published_at.strftime("%F %T %:z")}
tags:   #{post.tags.map {|x| x.name.downcase }.sort.inspect}
---
{% raw %}
#{post.body}
{% endraw %}
      EOS

      File.write(File.join(dir, filename), body)
    end
  end
end
