class PagesController < ApplicationController
  def show
    @page = Page.find_by_slug(params[:id]) || raise(ActiveRecord::RecordNotFound)
    fresh_when last_modified: @page.updated_at.utc, public: true
  end
end
