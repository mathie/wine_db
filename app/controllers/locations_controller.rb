class LocationsController < ApplicationController
  def index
    @locations = Location.paginated(page)
  end

  def show
    @location = Location.find(params.require(:id))
  end
end
