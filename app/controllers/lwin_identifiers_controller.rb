class LwinIdentifiersController < ApplicationController
  def index
    @lwin_identifiers = LwinIdentifier.paginated(params[:page])
  end
end
