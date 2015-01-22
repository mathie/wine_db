require 'rails_helper'

RSpec.describe LwinIdentifiersController do
  let(:lwin_identifiers_class) { class_spy('LwinIdentifier').as_stubbed_const }

  describe "GET index" do
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

    it "asks the model for a paginated list of identifiers" do
      do_get

      expect(lwin_identifiers_class).to have_received(:paginated)
    end

    it "passes @lwin_identifiers to the view" do
      do_get

      expect(assigns(:lwin_identifiers)).to eq(lwin_identifiers)
    end

    context 'with a search query' do
      def do_get
        get :index, q: 'chicken'
      end

      it "asks the model to search based on the query" do
        do_get

        expect(lwin_identifiers_class).to have_received(:search).with('chicken')
      end
    end
  end

  describe "GET show" do
    let(:lwin_identifier) { instance_spy('LwinIdentifier') }

    before(:each) do
      allow(lwin_identifiers_class).to receive(:find) { lwin_identifier }
    end

    def do_get
      get :show, id: 'uuid'
    end

    it "returns http success" do
      do_get

      expect(response).to have_http_status(:success)
    end

    it "renders the show template" do
      do_get

      expect(response).to render_template('show')
    end

    it "asks the model for the correct identifier" do
      do_get

      expect(lwin_identifiers_class).to have_received(:find).with('uuid')
    end

    it "passes @lwin_identifier on to the view" do
      do_get

      expect(assigns(:lwin_identifier)).to eq(lwin_identifier)
    end
  end
end
