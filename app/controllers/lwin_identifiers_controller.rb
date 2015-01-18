class LwinIdentifiersController < ApplicationController
  def index
    @lwin_identifiers = LwinIdentifier.paginated(page)
  end

  def show
    @lwin_identifier = LwinIdentifier.find(params.require(:id))
  end
end
