class ProducersController < ApplicationController
  def index
    @producers = Producer.paginated(params[:page])
  end

  def show
    @producer = Producer.find(params.require(:id))
  end
end
