require 'spec_helper'
require 'importers/lwin/spreadsheet'
require 'importers/lwin/live_wine'
require 'importers/lwin/combined_wine'
require 'importers/lwin/deleted_wine'


RSpec.describe Importers::Lwin::Spreadsheet do
  subject { described_class.new(fixture_database) }

  context 'with a valid (sample) database' do
    let(:fixture_database) {
      Rails.root.join(
        'spec', 'fixtures', 'importers', 'L-WIN_database_sample.xls'
      )
    }

    it 'opens the file without error' do
      expect {
        subject
      }.not_to raise_error
    end

    it 'can retrieve the spreadsheet version' do
      expect(subject.version).to eq('L-WIN_28112014')
    end

    it 'can retrieve the date updated from the version' do
      expect(subject.date_updated).to eq(Date.new(2014, 11, 28))
    end

    it 'has appropriate #inspect output' do
      expect(subject.inspect).to match(/<#Spreadsheet:[0-9A-F]+ version="L-WIN_28112014" date_updated=Fri, 28 Nov 2014>/)
    end

    describe 'iterating through all the wines' do
      before(:each) do
        @wines = []
        subject.each { |wine| @wines << wine }
      end

      it 'can iterate through all the wines' do
        expect(@wines.size).to eq(12)
      end

      it 'gets the right data for the first wine' do
        wine = @wines.first

        expect(wine).to be_a(Importers::Lwin::LiveWine)
        expect(wine.identifier).to eq('1000001')
        expect(wine.producer).to eq('Chapoutier')
        # ... etc, etc.
      end

      it 'gets the right data for the last wine' do
        wine = @wines.last

        expect(wine).to be_a(Importers::Lwin::DeletedWine)
        expect(wine.identifier).to eq('1003288')
      end
    end
  end

  context 'with an invalid database' do
    let(:fixture_database) do
      Rails.root.join(
        'spec', 'fixtures', 'importers', 'L-WIN_invalid_database_sample.xls'
      )
    end

    it 'raises an error when trying to open the file' do
      expect { subject }.to raise_error(Importers::Lwin::ParseError)
    end
  end
end
