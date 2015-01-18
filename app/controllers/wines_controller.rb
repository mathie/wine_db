class WinesController < ApplicationController
  def index
    @wines = Wine.paginated(page)
  end

  def show
    @wine = Wine.find(params.require(:id))
  end
end
