require 'rails_helper'

RSpec.describe ClassificationsController do
  let(:classifications_class) { class_spy('Classification').as_stubbed_const }

  describe "GET index" do
    let(:classifications) { [ instance_spy('Classification') ] }

    before(:each) do
      allow(classifications_class).to receive(:paginated) { classifications }
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

    it "asks the model for a paginated list of classifications" do
      do_get

      expect(classifications_class).to have_received(:paginated)
    end

    it "passes @classifications to the view" do
      do_get

      expect(assigns(:classifications)).to eq(classifications)
    end
  end

  describe "GET show" do
    let(:classification) { instance_spy('Classification') }

    before(:each) do
      allow(classifications_class).to receive(:find) { classification }
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

    it "asks the model for the correct classification" do
      do_get

      expect(classifications_class).to have_received(:find).with('uuid')
    end

    it "passes @classification on to the view" do
      do_get

      expect(assigns(:classification)).to eq(classification)
    end
  end
end
