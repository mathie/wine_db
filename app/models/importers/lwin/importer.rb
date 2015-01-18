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
              if identifier = LwinIdentifier.where(identifier: lwin_wine.identifier).take
                identifier.update!(
                  identifier: lwin_wine.identifier,
                  status: :deleted,
                  identifier_updated_at: lwin_wine.date_updated
                )
              else
                LwinIdentifier.create!(
                  identifier: lwin_wine.identifier,
                  status: :deleted,
                  identifier_updated_at: lwin_wine.date_updated
                )
              end
            when CombinedWine
              combined_wines << lwin_wine
            when LiveWine
              location = Location.find_or_create_by_tuple(lwin_wine.country, lwin_wine.region, lwin_wine.subregion)
              producer = if lwin_wine.producer.present?
                Producer.find_or_create_by!(name: lwin_wine.producer)
              else
                nil
              end

              classification = if lwin_wine.designation.present?
                Classification.find_or_create_by!(designation: lwin_wine.designation, classification: lwin_wine.classification)
              else
                nil
              end

              wine_type = case lwin_wine.type
              when :fortfied
                :fortified
              when nil
                :unknown_wine_type
              else
                lwin_wine.type
              end

              if identifier = LwinIdentifier.where(identifier: lwin_wine.identifier).take
                identifier.update!(
                  identifier: lwin_wine.identifier,
                  status: :live,
                  identifier_updated_at: lwin_wine.date_updated
                )

                identifier.wine.update!(
                  name: lwin_wine.wine || producer.try(:name),
                  colour: lwin_wine.colour || :unknown_colour,
                  wine_type: wine_type,
                  location: location,
                  producer: producer,
                  classification: classification
                )
              else
                wine = Wine.create!(
                  name: lwin_wine.wine || producer.try(:name),
                  colour: lwin_wine.colour || :unknown_colour,
                  wine_type: wine_type,
                  location: location,
                  producer: producer,
                  classification: classification
                )

                LwinIdentifier.create!(
                  identifier: lwin_wine.identifier,
                  status: :live,
                  wine: wine,
                  identifier_updated_at: lwin_wine.date_updated
                )
              end
            else
              raise "Unexpected wine type #{lwin_wine.type}"
            end
          end

          combined_wines.each do |lwin_wine|
            canonical_identifer = LwinIdentifier.where(identifier: lwin_wine.reference).take!
            if identifier = LwinIdentifier.where(identifier: lwin_wine.identifier).take
              identifier.update!(
                identifier: lwin_wine.identifier,
                status: :combined,
                wine_id: canonical_identifer.wine_id,
                identifier_updated_at: lwin_wine.date_updated
              )
            else
              LwinIdentifier.create!(
                identifier: lwin_wine.identifier,
                status: :combined,
                wine_id: canonical_identifer.wine_id,
                identifier_updated_at: lwin_wine.date_updated
              )
            end
          end
        end
      end
    end
  end
end