class LocationsController < ApplicationController
  def index
    @locations = scope.paginated(page)
  end

  def show
    @location = Location.find(params.require(:id))
  end

  private
  def scope
    scope = if location_id = params[:location_id]
      @location = Location.find(location_id)
      @location.children
    else
      scope = Location
    end

    if query = params[:query]
      scope.search(query)
    else
      # No parent scope, and no query, so just show top level locations.
      scope.where(parent_id: nil)
    end
  end
end
