module Importers
  module Lwin
    class Wine
      include ActiveModel::Validations
      include ActiveModel::AttributeMethods

      define_attribute_methods :identifier, :date_updated

      validates :identifier, presence: true
      validates :date_updated, presence: true

      def self.from_row(row)
        case row.status
        when :live
          LiveWine.new(
            identifier:     row.identifier,
            producer:       row.producer,
            wine:           row.wine,
            country:        row.country,
            region:         row.region,
            subregion:      row.subregion,
            colour:         row.colour,
            type:           row.type,
            designation:    row.designation,
            classification: row.classification,
            date_updated:   row.date_updated
          )
        when :combined
          CombinedWine.new(
            identifier:     row.identifier,
            producer:       row.producer,
            wine:           row.wine,
            country:        row.country,
            region:         row.region,
            subregion:      row.subregion,
            colour:         row.colour,
            type:           row.type,
            designation:    row.designation,
            classification: row.classification,
            reference:      row.reference,
            date_updated:   row.date_updated
          )
        when :deleted
          DeletedWine.new(
            identifier:   row.identifier,
            date_updated: row.date_updated
          )
        else
          raise "unrecognised status, '#{status}' for row, #{row.to_a.inspect}"
        end
      end

      def initialize(attributes = {})
        @attributes = {}
        attributes.each do |k, v|
          @attributes[k.to_s] = v
        end
      end

      private
      attr_reader :attributes

      def attribute(key)
        @attributes[key]
      end
    end
  end
end
