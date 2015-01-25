require 'spec_helper'

require 'importers/lwin/identifier_validator'

RSpec.describe Importers::Lwin::IdentifierValidator do
  let(:attribute) { 'attribute' }
  let(:errors)    { double('Errors', add: nil) }
  let(:record)    { double('Record', errors: errors) }
  let(:validator) { Importers::Lwin::IdentifierValidator.new(attributes: [ attribute ]) }

  def validate(identifier)
    validator.validate_each(record, attribute, identifier)
  end

  it 'does not add an error to the record for a valid identifier' do
    expect(errors).not_to receive(:add)

    validate('1234567')
  end

  describe 'adds an error to the record' do
    before(:each) do
      expect(errors).to receive(:add).with(attribute, "isn't a valid L-WIN identifier")
    end

    it 'if the identifier is nil' do
      validate nil
    end

    it 'if the identifier is blank' do
      validate ''
    end

    it 'if the identifier is too short' do
      validate '123456'
    end

    it 'if the identifier is too long' do
      validate '12345678'
    end

    it 'if the identifier contains something other than digits' do
      validator.validate_each(record, attribute, '123ABC7')
    end
  end
end
