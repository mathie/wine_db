class ClassificationsController < ApplicationController
  def index
    @classifications = Classification.paginated(params[:page])
  end

  def show
    @classification = Classification.find(params.require(:id))
  end
end
