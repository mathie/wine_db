class LwinIdentifiersController < ApplicationController
  def index
    @lwin_identifiers = scope.paginated(page)
  end

  def show
    @lwin_identifier = LwinIdentifier.find(params.require(:id))
  end

  private
  def scope
    scope = LwinIdentifier

    if query = params[:q]
      scope.search(query)
    else
      scope
    end
  end
end
