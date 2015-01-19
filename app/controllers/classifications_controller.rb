class ClassificationsController < ApplicationController
  def index
    @classifications = scope.paginated(page)
  end

  def show
    @classification = Classification.find(params.require(:id))
  end

  private
  def scope
    scope = Classification

    if query = params[:q]
      scope.search(query)
    else
      scope
    end
  end
end
