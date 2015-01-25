require 'rails_helper'
require 'models/concerns/searchable_spec'

RSpec.describe Classification do
  def factory(attributes = {})
    described_class.new({
      classification: 'AOC',
      designation: 'Grand Cru'
    }.merge(attributes))
  end

  it_behaves_like 'Searchable'

  describe 'validations' do
    it 'requires a designation' do
      classification = factory(designation: nil)

      expect(classification).not_to be_valid
      expect(classification.errors[:designation]).to include(/can't be blank/)
    end

    it 'does not require a classification' do
      classification = factory(classification: nil)

      expect(classification).to be_valid
    end

    it 'requires the combination of classification and designation to be unique' do
      original = factory
      original.save!

      duplicate = factory
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:classification]).to include(/has already been taken/)
    end
  end

  describe '.title' do
    it 'generates the right title with just a designation' do
      classification = factory(designation: 'AOC', classification: '')

      expect(classification.title).to eq('AOC')
    end

    it 'generates the right title with a designation and classification' do
      classification = factory(designation: 'AOC', classification: 'grand_cru')

      expect(classification.title).to eq('AOC - Grand Cru')
    end
  end

  describe 'pagination' do
    before(:each) do
      allow(described_class).to receive(:order) { described_class }
      allow(described_class).to receive(:page) { described_class }
    end

    it 'orders by designation and classification' do
      described_class.paginated(2)

      expect(described_class).to have_received(:order).with(:designation, :classification)
    end

    it 'retrieves the correct page' do
      described_class.paginated(2)

      expect(described_class).to have_received(:page).with(2)
    end
  end
end
