class ProducersController < ApplicationController
  def index
    @producers = scope.paginated(page)
  end

  def show
    @producer = Producer.find(params.require(:id))
  end

  private
  def scope
    scope = Producer

    if query = params[:query]
      scope.search(query)
    else
      scope
    end
  end
end
