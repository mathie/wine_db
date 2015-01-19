require 'importers/lwin/spreadsheet'

module Importers
  module Lwin
    class Importer
      def initialize(io_or_path)
        @spreadsheet = Spreadsheet.new(io_or_path)
      end

      def import
        LwinIdentifier.transaction do
          combined_wines = []

          @spreadsheet.each do |lwin_wine|
            case lwin_wine
            when DeletedWine
              create_or_update_identifier!(lwin_wine, :deleted)
            when CombinedWine
              # Combined wines have to be done last so the canonical version is already
              # somewhere in the system to link to (to maintain referential integrity).
              combined_wines << lwin_wine
            when LiveWine
              wine = create_or_update_wine!(lwin_wine)
              identifier = create_or_update_identifier!(lwin_wine, :live, wine.id)
            else
              raise "Unexpected wine type #{lwin_wine.type}"
            end
          end

          import_combined_wines(combined_wines)
        end
      end

      private
      def create_or_update_identifier!(lwin_wine, status, wine_id = nil)
        if identifier = LwinIdentifier.where(identifier: lwin_wine.identifier).take
          identifier.update!(
            identifier: lwin_wine.identifier,
            status: status,
            wine_id: wine_id,
            identifier_updated_at: lwin_wine.date_updated
          )
        else
          identifier = LwinIdentifier.create!(
            identifier: lwin_wine.identifier,
            status: status,
            wine_id: wine_id,
            identifier_updated_at: lwin_wine.date_updated
          )
        end

        identifier
      end

      def create_or_update_wine!(lwin_wine)
        location = find_or_create_location!(lwin_wine)
        producer = find_or_create_producer!(lwin_wine)
        classification = find_or_create_classification!(lwin_wine)
        wine_type = wine_type_for(lwin_wine)
        name = lwin_wine.wine || producer.try(:name)
        colour = lwin_wine.colour || :unknown_colour

        if wine = Wine.where(name: name, producer: producer).take
          wine.update!(
            name: name,
            colour: colour,
            wine_type: wine_type,
            location: location,
            producer: producer,
            classification: classification
          )
        else
          wine = Wine.create!(
            name: name,
            colour: colour,
            wine_type: wine_type,
            location: location,
            producer: producer,
            classification: classification
          )
        end

        wine
      end

      def find_or_create_location!(lwin_wine)
        Location.find_or_create_by_tuple(lwin_wine.country, lwin_wine.region, lwin_wine.subregion)
      end

      def find_or_create_producer!(lwin_wine)
        if lwin_wine.producer.present?
          Producer.find_or_create_by!(name: lwin_wine.producer)
        else
          nil
        end
      end

      def find_or_create_classification!(lwin_wine)
        if lwin_wine.designation.present?
          Classification.find_or_create_by!(designation: lwin_wine.designation, classification: lwin_wine.classification)
        else
          nil
        end
      end

      def wine_type_for(lwin_wine)
        case lwin_wine.type
        when :fortfied
          :fortified
        when nil
          :unknown_wine_type
        else
          lwin_wine.type
        end
      end

      def import_combined_wines(combined_wines)
        combined_wines.each do |lwin_wine|
          canonical_identifer = LwinIdentifier.where(identifier: lwin_wine.reference).take!
          create_or_update_identifier!(lwin_wine, :combined, canonical_identifer.wine_id)
        end
      end
    end
  end
end