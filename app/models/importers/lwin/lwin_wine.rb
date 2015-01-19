module Importers
  module Lwin
    class LwinWine
      include ActiveModel::Validations
      include ActiveModel::AttributeMethods

      define_attribute_methods :identifier, :date_updated

      validates :identifier, presence: true
      validates :date_updated, presence: true

      def self.from_row(row)
        case row.status
        when :live
          LiveWine.from_row(row)
        when :combined
          CombinedWine.from_row(row)
        when :deleted
          DeletedWine.from_row(row)
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
