require 'rails_helper'

RSpec.describe Classification do
  def factory(attributes = {})
    described_class.new({
      classification: 'AOC',
      designation: 'Grand Cru'
    }.merge(attributes))
  end

  describe 'validations' do
    it 'requires a classification' do
      classification = factory(classification: nil)

      expect(classification).not_to be_valid
      expect(classification.errors[:classification]).to include(/can't be blank/)
    end

    it 'does not require a designation' do
      classification = factory(designation: nil)

      expect(classification).to be_valid
    end

    it 'requires the combination of classification and designation to be unique' do
      original = factory
      original.save!

      duplicate = factory
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:classification]).to include(/has already been taken/)
      expect(duplicate.errors[:designation]).to include(/has already been taken/)
    end
  end
end
