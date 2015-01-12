require 'rails_helper'

RSpec.describe Producer do
  def factory(attributes = {})
    described_class.new({
      name: 'Trimbach'
    }.merge(attributes))
  end

  describe 'validations' do
    it 'requires a name' do
      producer = factory(name: nil)

      expect(producer).not_to be_valid
      expect(producer.errors[:name]).to include(/can't be blank/)
    end

    it 'requires the name to be unique' do
      original = factory
      original.save!

      duplicate = factory
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include(/has already been taken/)
    end
  end
end
