module TagHelper
  def linked_tag_list(tags)
    tags.sort_by {|x| x.name.downcase }.collect {|tag| link_to(h(tag.name.downcase), posts_path(:tag => tag))}.join(", ".html_safe)
  end
end
