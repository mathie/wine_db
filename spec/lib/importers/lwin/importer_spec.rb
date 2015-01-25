require 'rails_helper'
require 'importers/lwin/importer'

RSpec.describe Importers::Lwin::Importer do
  let(:fixture_file) { Rails.root.join('spec', 'fixtures', 'importers','L-WIN_database_sample.xls' ) }
  let(:subject) { described_class.new(fixture_file) }

  it 'can be constructed successfully' do
    expect {
      subject
    }.not_to raise_error
  end

  it 'runs the import successfully' do
    expect {
      subject.import
    }.not_to raise_error
  end

  it 'creates 12 new identifiers' do
    expect {
      subject.import
    }.to change(LwinIdentifier, :count).by(12)
  end

  it 'creates 5 live identifiers' do
    expect {
      subject.import
    }.to change(LwinIdentifier.live, :count).by(5)
  end

  it 'creates 5 combined identifiers' do
    expect {
      subject.import
    }.to change(LwinIdentifier.combined, :count).by(5)
  end

  it 'creates 2 deleted identifiers' do
    expect {
      subject.import
    }.to change(LwinIdentifier.deleted, :count).by(2)
  end

  it 'creates 5 wines' do
    expect {
      subject.import
    }.to change(Wine, :count).by(5)
  end

  it 'creates 5 locations' do
    expect {
      subject.import
    }.to change(Location, :count).by(5)
  end

  it 'correctly imports the first wine' do
    subject.import

    wine = Wine.where(name: 'Riesling Schieferkopf Lieu Dit Buehl').take!

    expect(wine.name).to eq('Riesling Schieferkopf Lieu Dit Buehl')
    expect(wine.colour).to eq('white')
    expect(wine.wine_type).to eq('still')
    expect(wine.classification.designation).to eq('aoc')
    expect(wine.location.name).to eq('Alsace')
    expect(wine.producer.name).to eq('Chapoutier')
    expect(wine.canonical_identifier.identifier).to eq("1000001")
  end
end
