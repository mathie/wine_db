require 'rails_helper'

RSpec.describe LocationsController do
  let(:locations_class) { class_spy('Location').as_stubbed_const }

  describe "GET index" do
    let(:locations) { [ instance_spy('Location') ] }

    before(:each) do
      allow(locations_class).to receive(:paginated) { locations }
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

    it "asks the model for a paginated list of locations" do
      do_get

      expect(locations_class).to have_received(:paginated)
    end

    it "passes @locations to the view" do
      do_get

      expect(assigns(:locations)).to eq(locations)
    end

    context 'with a search query' do
      def do_get
        get :index, q: 'chicken'
      end

      it "asks the model to search based on the query" do
        do_get

        expect(locations_class).to have_received(:search).with('chicken')
      end
    end
  end

  describe "GET show" do
    let(:location) { instance_spy('Location') }

    before(:each) do
      allow(locations_class).to receive(:find) { location }
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

    it "asks the model for the correct location" do
      do_get

      expect(locations_class).to have_received(:find).with('uuid')
    end

    it "passes @location on to the view" do
      do_get

      expect(assigns(:location)).to eq(location)
    end
  end
end
