module TagHelper
  def linked_tag_list(tags)
     raw tags.sort_by {|x| x.name.downcase }.collect {|tag| link_to(h(tag.name.downcase), posts_path(:tag => tag.name.downcase))}.join(", ")
  end
end
