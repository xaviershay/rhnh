ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resource :session

    admin.resource :dashboard, :controller => 'dashboard'

    admin.resources :posts
    admin.resources :pages
    admin.resources :comments,
      :collection => {:spam => :delete},
      :member     => {:mark_as_spam => :post, :mark_as_ham => :post}
    admin.resources :posts, :new => {:preview => :post}
    admin.resources :pages, :new => {:preview => :post}
    admin.resources :tags
    admin.resources :undo_items, :member => {:undo => :post}
  end

  map.admin_health '/admin/health/:action', :controller => 'admin/health', :action => 'index'

  map.connect '/admin', :controller => 'admin/dashboard', :action => 'show'
  map.connect '/admin/api', :controller => 'admin/api', :action => 'index'
  map.archives '/archives', :controller => 'archives', :action => 'index'

  map.connect '/search', :controller => 'search', :action => 'show'

  map.root :controller => 'posts', :action => 'index'
  map.resources :posts

  map.resources :pages

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug/comments/new', :controller => 'comments', :action => 'new'
  map.connect ':year/:month/:day/:slug/comments.:format', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :requirements => { :year => /\d+/ }
  map.posts_with_tag ':tag', :controller => 'posts', :action => 'index'
  map.formatted_posts_with_tag ':tag.:format', :controller => 'posts', :action => 'index'

  # Legacy routes
  map.redirect '/feed/atom.xml', 'http://feeds.feedburner.com/rhnh', :permanent => true
end
