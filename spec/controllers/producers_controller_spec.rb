require 'rails_helper'

RSpec.describe ProducersController do
  let(:producers_class) { class_spy('Producer').as_stubbed_const }

  describe "GET index" do
    let(:producers) { [ instance_spy('Producer') ] }

    before(:each) do
      allow(producers_class).to receive(:paginated) { producers }
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

    it "asks the model for a paginated list of producers" do
      do_get

      expect(producers_class).to have_received(:paginated)
    end

    it "passes @producers to the view" do
      do_get

      expect(assigns(:producers)).to eq(producers)
    end
  end

  describe "GET show" do
    let(:producer) { instance_spy('Producer') }

    before(:each) do
      allow(producers_class).to receive(:find) { producer }
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

    it "asks the model for the correct producer" do
      do_get

      expect(producers_class).to have_received(:find).with('uuid')
    end

    it "passes @producer on to the view" do
      do_get

      expect(assigns(:producer)).to eq(producer)
    end
  end
end
