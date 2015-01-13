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
end
