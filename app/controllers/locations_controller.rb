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
      Location.where(parent_id: nil)
    end

    if query = params[:q]
      scope.search(query)
    else
      scope
    end
  end
end
