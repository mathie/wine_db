require 'rails_helper'

RSpec.describe Wine do
  def factory(attributes = {})
    Wine.new({
      name: 'Riesling Schieferkopf Lieu Dit Buehl',
      colour: :white,
      wine_type: :still,
      location: Location.new(name: 'France')
    }.merge(attributes))
  end

  describe 'validations' do
    it 'requires a name' do
      wine = factory(name: '')

      expect(wine).not_to be_valid
      expect(wine.errors[:name]).to include(/can't be blank/)
    end

    it 'requires a colour' do
      wine = factory(colour: '')

      expect(wine).not_to be_valid
      expect(wine.errors[:colour]).to include(/can't be blank/)
    end

    it 'requires a wine type' do
      wine = factory(wine_type: '')

      expect(wine).not_to be_valid
      expect(wine.errors[:wine_type]).to include(/can't be blank/)
    end
  end

  describe 'pagination' do
    before(:each) do
      allow(described_class).to receive(:order) { described_class }
      allow(described_class).to receive(:page) { described_class }
    end

    it 'orders by name' do
      described_class.paginated(2)

      expect(described_class).to have_received(:order).with(:name)
    end

    it 'retrieves the correct page' do
      described_class.paginated(2)

      expect(described_class).to have_received(:page).with(2)
    end
  end

  describe '.canonical_identifier' do
    let!(:wine) { factory.tap { |factory| factory.save! } }
    let!(:canonical_identifier) {
      LwinIdentifier.create!(
        identifier: '42',
        status: :live,
        wine: wine,
        identifier_updated_at: Time.now
      )
    }

    it 'retrieve the live L-Win identifier' do
      expect(wine.canonical_identifier).to eq(canonical_identifier)
    end
  end

  describe '.combined_identifiers' do
    let!(:wine) { factory.tap { |factory| factory.save! } }
    let!(:combined_identifiers) { [
      LwinIdentifier.create!(
        identifier: '42',
        status: :combined,
        wine: wine,
        identifier_updated_at: Time.now
      ),
      LwinIdentifier.create!(
        identifier: '54',
        status: :combined,
        wine: wine,
        identifier_updated_at: Time.now
      )
    ] }

    it 'retrieve the combined L-Win identifiers' do
      expect(wine.combined_identifiers).to eq(combined_identifiers)
    end
  end
end
