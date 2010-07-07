class SearchController < ApplicationController
  
  def results
    unless current_user.can_search?
      flash[:error] = "Search has been disabled"
      redirect_to root_path
      return
    end

    @comments = Comment.search(
                  params[:search],
                  :retry_stale => true,
                  :order => 'created_at DESC',
                  :with => { :project_id => my_project_ids }).compact
  end
  
  protected
  
    def my_project_ids
      current_user.projects.collect { |p| p.id }
    end
end