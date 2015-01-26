require 'rails_helper'

RSpec.describe WinesController do
  let(:wines_class) { class_spy('Wine').as_stubbed_const }

  describe 'GET index' do
    let(:wines) { [instance_spy('Wine')] }

    before(:each) do
      allow(wines_class).to receive(:paginated) { wines }
    end

    def do_get
      get :index
    end

    it 'returns http success' do
      do_get

      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      do_get

      expect(response).to render_template('index')
    end

    it 'asks the model for a paginated list of wines' do
      do_get

      expect(wines_class).to have_received(:paginated)
    end

    it 'passes @wines to the view' do
      do_get

      expect(assigns(:wines)).to eq(wines)
    end

    context 'with a search query' do
      def do_get
        get :index, q: 'chicken'
      end

      it 'asks the model to search based on the query' do
        do_get

        expect(wines_class).to have_received(:search).with('chicken')
      end
    end
  end

  describe 'GET show' do
    let(:wine) { instance_spy('Wine') }

    before(:each) do
      allow(wines_class).to receive(:find) { wine }
    end

    def do_get
      get :show, id: 'uuid'
    end

    it 'returns http success' do
      do_get

      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      do_get

      expect(response).to render_template('show')
    end

    it 'asks the model for the correct wine' do
      do_get

      expect(wines_class).to have_received(:find).with('uuid')
    end

    it 'passes @wine on to the view' do
      do_get

      expect(assigns(:wine)).to eq(wine)
    end
  end
end
