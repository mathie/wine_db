class WinesController < ApplicationController
  def index
    @wines = scope.paginated(page)
  end

  def show
    @wine = Wine.find(params.require(:id))
  end

  private
  def scope
    if location_id = params[:location_id]
      @location = Location.find(location_id)
      @location.wines
    else
      Wine
    end
  end
end
