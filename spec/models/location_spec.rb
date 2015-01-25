require 'rails_helper'
require 'models/concerns/searchable_spec'

RSpec.describe Location do
  def country_factory(attributes = {})
    described_class.new({
      name: 'France'
    }.merge(attributes))
  end

  def region_factory(attributes = {})
    described_class.new({
      name: 'Alsace',
      parent: country_factory
    }.merge(attributes))
  end

  def subregion_factory(attributes = {})
    described_class.new({
      name: 'Alsace',
      parent: region_factory
    }.merge(attributes))
  end

  it_behaves_like 'Searchable'

  describe 'validations' do
    it 'requires a name' do
      location = country_factory(name: nil)

      expect(location).not_to be_valid
      expect(location.errors[:name]).to include(/can't be blank/)
    end

    describe 'requires the name to be unique within the geographical area' do
      it 'does not allow two top level locations with the same name' do
        original = country_factory
        original.save!

        duplicate = country_factory
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include(/has already been taken/)
      end

      it 'does not allow two regions of the same name' do
        parent = country_factory
        parent.save!

        original = region_factory(parent: parent)
        original.save!

        duplicate = region_factory(parent: parent)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include(/has already been taken/)
      end
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

  describe '.find_or_create_by_tuple' do
    context 'for a country' do
      context 'which does not already exist' do
        it 'creates the country' do
          country = described_class.find_or_create_by_tuple('France')

          expect(country).to be_persisted
          expect(country.name).to eq('France')
        end
      end

      context 'which already exists' do
        before(:each) do
          @country = country_factory(name: 'France')
          @country.save!
        end

        it 'returns the existing country' do
          country = described_class.find_or_create_by_tuple('France')

          expect(country).to be_persisted
          expect(country).to eq(@country)
        end
      end
    end

    context 'for a region' do
      context 'where the country already exists' do
        before(:each) do
          @country = country_factory(name: 'France')
          @country.save!
        end

        context 'and the region does not exist' do
          it 'creates and returns the region' do
            region = described_class.find_or_create_by_tuple('France', 'Alsace')

            expect(region).to be_persisted
            expect(region.name).to eq('Alsace')
            expect(region.parent).to eq(@country)
          end
        end

        context 'and the region already exists' do
          before(:each) do
            @region = @country.children.create!(name: 'Alsace')
          end

          it 'returns the existing region' do
            region = described_class.find_or_create_by_tuple('France', 'Alsace')

            expect(region).to be_persisted
            expect(region).to eq(@region)
          end
        end
      end

      context 'where the country (nor region) do not already exist' do
        it 'creates and returns the region' do
          region = described_class.find_or_create_by_tuple('France', 'Alsace')

          expect(region).to be_persisted
          expect(region.name).to eq('Alsace')
          expect(region.parent.name).to eq('France')
        end
      end
    end

    context 'for a subregion' do
      context 'where the country already exists' do
        before(:each) do
          @country = country_factory(name: 'France')
          @country.save!
        end

        context 'and the region already exists' do
          before(:each) do
            @region = @country.children.create!(name: 'Alsace')
          end

          context 'and the subregion already exists' do
            before(:each) do
              @subregion = @region.children.create!(name: 'Villeneuve')
            end

            it 'returns the existing subregion' do
              subregion = described_class.find_or_create_by_tuple('France', 'Alsace', 'Villeneuve')

              expect(subregion).to be_persisted
              expect(subregion).to eq(@subregion)
            end
          end

          context 'and the subregion does not exist' do
            it 'creates and returns the subregion' do
              subregion = described_class.find_or_create_by_tuple('France', 'Alsace', 'Villeneuve')

              expect(subregion).to be_persisted
              expect(subregion.name).to eq('Villeneuve')
              expect(subregion.parent).to eq(@region)
            end
          end
        end

        context 'and the region does not exist' do
          it 'creates and returns the subregion' do
            subregion = described_class.find_or_create_by_tuple('France', 'Alsace', 'Villeneuve')

            expect(subregion).to be_persisted
            expect(subregion.name).to eq('Villeneuve')
            expect(subregion.parent.name).to eq('Alsace')
            expect(subregion.parent.parent).to eq(@country)
          end
        end
      end

      context 'where the country, nor region, nor subregion exist' do
        it 'creates and returns the region' do
          subregion = described_class.find_or_create_by_tuple('France', 'Alsace', 'Villeneuve')

          expect(subregion).to be_persisted
          expect(subregion.name).to eq('Villeneuve')
          expect(subregion.parent.name).to eq('Alsace')
          expect(subregion.parent.parent.name).to eq('France')
        end
      end
    end
  end
end
