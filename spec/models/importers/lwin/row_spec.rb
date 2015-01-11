require 'spec_helper'

RSpec.describe Importers::Lwin::Row do
  let(:subject) { described_class.new(row_data) }

  context 'for a row describing a full wine' do
    let (:row_data) {
      [
        '1000001',                              # L-Win Identifier
        'Live',                                 # Status
        'Chapoutier',                           # Producer
        'Riesling Schieferkopf Lieu Dit Buehl', # Wine
        'France',                               # Country
        'Alsace',                               # Region
        'NA',                                   # Sub-Region
        'White',                                # Colour
        'Still',                                # Type
        'AOC',                                  # Designation
        'NA',                                   # Classification
        nil,                                    # Reference
        '08/06/2011'                            # Date Update
      ]
    }

    it 'can be instantiated with a valid row of data' do
      expect {
        subject
      }.not_to raise_error
    end

    it 'can extract the identifier' do
      expect(subject.identifier).to eq('1000001')
    end

    it 'can extract the status' do
      expect(subject.status).to be(:live)
    end

    it 'can extract the producer' do
      expect(subject.producer).to eq('Chapoutier')
    end

    it 'can extract the wine' do
      expect(subject.wine).to eq('Riesling Schieferkopf Lieu Dit Buehl')
    end

    it 'can extract the country' do
      expect(subject.country).to eq('France')
    end

    it 'can extract the region' do
      expect(subject.region).to eq('Alsace')
    end

    it 'can extract the subregion' do
      expect(subject.subregion).to be_nil
    end

    it 'can extract the colour' do
      expect(subject.colour).to be(:white)
    end

    it 'can extract the type' do
      expect(subject.type).to be(:still)
    end

    it 'can extract the designation' do
      expect(subject.designation).to be(:aoc)
    end

    it 'can extract the classification' do
      expect(subject.classification).to be_nil
    end

    it 'can extract the reference' do
      expect(subject.reference).to be_nil
    end

    it 'can extract the date updated' do
      expect(subject.date_updated).to eq(Date.new(2011, 6, 8))
    end
  end

  context 'for a row describing a combined wine' do
    context 'which has all its own information' do
      let (:row_data) {
        [
          '1000131',
          'Combined',
          'Trimbach',
          'Clos St Hune',
          'France',
          'Alsace',
          'Hunawihr',
          'White',
          'Still',
          'AOC',
          'Grand Cru',
          '1316384',
          '24/11/2014'
        ]
      }

      it 'can be instantiated with a valid row of data' do
        expect {
          subject
        }.not_to raise_error
      end

      it 'can extract the identifier' do
        expect(subject.identifier).to eq('1000131')
      end

      it 'can extract the status' do
        expect(subject.status).to be(:combined)
      end

      it 'can extract the producer' do
        expect(subject.producer).to eq('Trimbach')
      end

      it 'can extract the wine' do
        expect(subject.wine).to eq('Clos St Hune')
      end

      it 'can extract the country' do
        expect(subject.country).to eq('France')
      end

      it 'can extract the region' do
        expect(subject.region).to eq('Alsace')
      end

      it 'can extract the subregion' do
        expect(subject.subregion).to eq('Hunawihr')
      end

      it 'can extract the colour' do
        expect(subject.colour).to be(:white)
      end

      it 'can extract the type' do
        expect(subject.type).to be(:still)
      end

      it 'can extract the designation' do
        expect(subject.designation).to be(:aoc)
      end

      it 'can extract the classification' do
        expect(subject.classification).to be(:grand_cru)
      end

      it 'can extract the reference' do
        expect(subject.reference).to eq('1316384')
      end

      it 'can extract the date updated' do
        expect(subject.date_updated).to eq(Date.new(2014, 11, 24))
      end
    end

    context 'which has very little information of its own' do
      let (:row_data) {
        [
          '1000447',
          'Combined',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '1148042',
          '22/02/2012'
        ]
      }
      it 'can be instantiated with a valid row of data' do
        expect {
          subject
        }.not_to raise_error
      end

      it 'can extract the identifier' do
        expect(subject.identifier).to eq('1000447')
      end

      it 'can extract the status' do
        expect(subject.status).to be(:combined)
      end

      it 'can extract the producer' do
        expect(subject.producer).to be_nil
      end

      it 'can extract the wine' do
        expect(subject.wine).to be_nil
      end

      it 'can extract the country' do
        expect(subject.country).to be_nil
      end

      it 'can extract the region' do
        expect(subject.region).to be_nil
      end

      it 'can extract the subregion' do
        expect(subject.subregion).to be_nil
      end

      it 'can extract the colour' do
        expect(subject.colour).to be_nil
      end

      it 'can extract the type' do
        expect(subject.type).to be_nil
      end

      it 'can extract the designation' do
        expect(subject.designation).to be_nil
      end

      it 'can extract the classification' do
        expect(subject.classification).to be_nil
      end

      it 'can extract the reference' do
        expect(subject.reference).to eq('1148042')
      end

      it 'can extract the date updated' do
        expect(subject.date_updated).to eq(Date.new(2012, 2, 22))
      end
    end
  end

  context 'for a row describing a deleted wine' do
    context 'which has all its own information' do
      let (:row_data) {
        [
          '1026074',
          'Deleted',
          'Clos Frantin',
          'Vosne Romanee Champs Perdrix',
          'France',
          'Burgundy',
          'Vosne Romanee',
          'Red',
          'Still',
          'AOC',
          '1er Cru',
          '',
          '20/11/2014'
        ]
      }

      it 'can be instantiated with a valid row of data' do
        expect {
          subject
        }.not_to raise_error
      end

      it 'can extract the identifier' do
        expect(subject.identifier).to eq('1026074')
      end

      it 'can extract the status' do
        expect(subject.status).to be(:deleted)
      end

      it 'can extract the producer' do
        expect(subject.producer).to eq('Clos Frantin')
      end

      it 'can extract the wine' do
        expect(subject.wine).to eq('Vosne Romanee Champs Perdrix')
      end

      it 'can extract the country' do
        expect(subject.country).to eq('France')
      end

      it 'can extract the region' do
        expect(subject.region).to eq('Burgundy')
      end

      it 'can extract the subregion' do
        expect(subject.subregion).to eq('Vosne Romanee')
      end

      it 'can extract the colour' do
        expect(subject.colour).to be(:red)
      end

      it 'can extract the type' do
        expect(subject.type).to be(:still)
      end

      it 'can extract the designation' do
        expect(subject.designation).to be(:aoc)
      end

      it 'can extract the classification' do
        expect(subject.classification).to be(:'1er_cru')
      end

      it 'can extract the reference' do
        expect(subject.reference).to be_nil
      end

      it 'can extract the date updated' do
        expect(subject.date_updated).to eq(Date.new(2014, 11, 20))
      end
    end

    context 'which has very little information of its own' do
      let (:row_data) {
        [
          '1024575',
          'Deleted',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '',
          '18/02/2013'
        ]
      }
      it 'can be instantiated with a valid row of data' do
        expect {
          subject
        }.not_to raise_error
      end

      it 'can extract the identifier' do
        expect(subject.identifier).to eq('1024575')
      end

      it 'can extract the status' do
        expect(subject.status).to be(:deleted)
      end

      it 'can extract the producer' do
        expect(subject.producer).to be_nil
      end

      it 'can extract the wine' do
        expect(subject.wine).to be_nil
      end

      it 'can extract the country' do
        expect(subject.country).to be_nil
      end

      it 'can extract the region' do
        expect(subject.region).to be_nil
      end

      it 'can extract the subregion' do
        expect(subject.subregion).to be_nil
      end

      it 'can extract the colour' do
        expect(subject.colour).to be_nil
      end

      it 'can extract the type' do
        expect(subject.type).to be_nil
      end

      it 'can extract the designation' do
        expect(subject.designation).to be_nil
      end

      it 'can extract the classification' do
        expect(subject.classification).to be_nil
      end

      it 'can extract the reference' do
        expect(subject.reference).to be_nil
      end

      it 'can extract the date updated' do
        expect(subject.date_updated).to eq(Date.new(2013, 2, 18))
      end
    end
  end
end
