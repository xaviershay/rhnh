module NavigationHelper
  def page_links_for_navigation
    link = Struct.new(:name, :url)
    [link.new("Home", posts_path),
     link.new("Archives", archives_path)] + 
      Page.find(:all, :order => 'title').collect {|page| link.new(page.title, page_path(page))}
  end

  def category_links_for_navigation
    link = Struct.new(:name, :url)
    ["Code", "Ruby", "Life", "Food", "Ethics"].collect {|label| link.new(label, posts_path(:tag => label)) }
  end

  def class_for_tab(tab_name, index)
    classes = []
    classes << 'current' if "admin/#{tab_name.downcase}" == params[:controller]
    classes << 'first'   if index == 0
    classes.join(' ')
  end
end
