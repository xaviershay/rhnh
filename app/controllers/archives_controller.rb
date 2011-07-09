class ArchivesController < ApplicationController
  def index
    if stale?(last_modified: (Post.maximum(:updated_at) || EPOCH).utc, public: true)
      @months = Post.find_all_grouped_by_month
    end
  end
end
