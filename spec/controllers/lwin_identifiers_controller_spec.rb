require 'rails_helper'

RSpec.describe LwinIdentifiersController do

  describe "GET index" do
    let(:lwin_identifiers_class) { class_spy('LwinIdentifier').as_stubbed_const }
    let(:lwin_identifiers) { [ instance_spy('LwinIdentifier') ] }

    before(:each) do
      allow(lwin_identifiers_class).to receive(:paginated) { lwin_identifiers }
    end

    def do_get
      get :index
    end

    it "returns http success" do
      do_get

      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      do_get

      expect(response).to render_template('index')
    end

    it "asks the view for a paginated list of identifiers" do
      do_get

      expect(lwin_identifiers_class).to have_received(:paginated)
    end

    it "passes @lwin_identifiers to the view" do
      do_get

      expect(assigns(:lwin_identifiers)).to eq(lwin_identifiers)
    end
  end

end
