require 'rails_helper'

RSpec.describe LwinIdentifier do
  def factory(attributes = {})
    described_class.new({
      identifier: 1000001,
      status: :live,
      identifier_updated_at: Date.new(2011, 6, 8),
      wine: Wine.new(name: 'Reisling')
    }.merge(attributes))
  end

  describe 'validations' do
    it 'requires an identifier' do
      wine = factory(identifier: '')

      expect(wine).not_to be_valid
      expect(wine.errors[:identifier]).to include(/can't be blank/)
    end

    it 'requires a status' do
      wine = factory(status: '')

      expect(wine).not_to be_valid
      expect(wine.errors[:status]).to include(/can't be blank/)
    end

    it 'requires an updated date' do
      wine = factory(identifier_updated_at: '')

      expect(wine).not_to be_valid
      expect(wine.errors[:identifier_updated_at]).to include(/can't be blank/)
    end

    it 'requires a wine if the status is live' do
      wine = factory(status: :live, wine: nil)

      expect(wine).not_to be_valid
      expect(wine.errors[:wine]).to include(/can't be blank/)
    end

    it 'requires a wine if the status is combined' do
      wine = factory(status: :combined, wine: nil)

      expect(wine).not_to be_valid
      expect(wine.errors[:wine]).to include(/can't be blank/)
    end

    it 'does not require a wine if the status is deleted' do
      wine = factory(status: :deleted, wine: nil)

      expect(wine).to be_valid
    end
  end

  describe 'pagination' do
    before(:each) do
      allow(described_class).to receive(:order) { described_class }
      allow(described_class).to receive(:page) { described_class }
    end

    it 'orders by identifier' do
      described_class.paginated(2)

      expect(described_class).to have_received(:order).with(:identifier)
    end

    it 'retrieves the correct page' do
      described_class.paginated(2)

      expect(described_class).to have_received(:page).with(2)
    end
  end
end
