require 'rails_helper'

module Importers
  module Lwin
    RSpec.describe Wine do
      describe '#from_row' do
        subject {  }

        context 'for a live wine' do
          let!(:wine_class) { class_spy('LiveWine').as_stubbed_const }
          let(:row) { instance_spy('Row', status: :live) }

          it 'correctly constructs the right wine' do
            wine = described_class.from_row(row)

            expect(wine_class).to have_received(:new)
          end
        end

        context 'for a deleted wine' do
          let!(:wine_class) { class_spy('DeletedWine').as_stubbed_const }
          let(:row) { instance_spy('Row', status: :deleted) }

          it 'correctly constructs the right wine' do
            wine = described_class.from_row(row)

            expect(wine_class).to have_received(:new)
          end
        end

        context 'for a combined wine' do
          let!(:wine_class) { class_spy('CombinedWine').as_stubbed_const }
          let(:row) { instance_spy('Row', status: :combined) }

          it 'correctly constructs the right wine' do
            wine = described_class.from_row(row)

            expect(wine_class).to have_received(:new)
          end
        end

        context 'for an unexpected status' do
          let(:row) { instance_spy('Row', status: :different) }

          it 'correctly constructs a live wine' do
            expect {
              described_class.from_row(row)
            }.to raise_error
          end
        end
      end
    end
  end
end
