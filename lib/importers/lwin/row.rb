module Importers
  module Lwin
    class Row
      INVALID_CELLS = [ 'NA', '-' ]

      def initialize(row)
        @row = row
      end

      def inspect
        attributes = [
          :identifier, :status, :producer, :wine,
          :country, :region, :subregion,
          :colour, :type, :designation, :classification,
          :reference, :date_updated
        ].map { |k| "#{k}=#{(send k).inspect}" }

        "<Row:#{object_id} #{attributes.join(', ')}>"
      end

      def identifier
        extract_lwin_identifier(0)
      end

      def status
        extract_column_value(1) { |value| value.downcase.to_sym }
      end

      def producer
        extract_column_value(2)
      end

      def wine
        extract_column_value(3)
      end

      def country
        extract_column_value(4)
      end

      def region
        extract_column_value(5)
      end

      def subregion
        extract_column_value(6)
      end

      def colour
        extract_column_symbol_value(7)
      end

      def type
        extract_column_symbol_value(8)
      end

      def designation
        extract_column_symbol_value(9)
      end

      def classification
        extract_column_symbol_value(10)
      end

      def reference
        extract_lwin_identifier(11)
      end

      def date_updated
        extract_column_value(12) { |value| value.to_date }
      end

      private
      attr_reader :row

      def extract_column_value(column)
        value = row[column]
        if value.present? && !INVALID_CELLS.include?(value)
          block_given? ? yield(value) : value
        else
          nil
        end
      end

      def extract_lwin_identifier(column)
        extract_column_value(column) { |value| value.to_i.to_s }
      end

      def extract_column_symbol_value(column)
        extract_column_value(column) do |value|
          value.gsub(' ', '').underscore.to_sym
        end
      end
    end
  end
end