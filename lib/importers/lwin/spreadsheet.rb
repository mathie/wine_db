require 'importers/lwin/live_wine'
require 'importers/lwin/row'

module Importers
  module Lwin
    class ParseError < StandardError
    end

    class Spreadsheet
      def initialize(io_or_path)
        @workbook = ::Spreadsheet.open(io_or_path)

        # Sanity check it's maybe the right spreadsheet
        unless valid_workbook?
          raise ParseError, "This is not an L-WIN spreadsheet."
        end
      end

      def inspect
        "<#Spreadsheet:#{object_id}> version=#{version.inspect} date_updated=#{date_updated.inspect}>"
      end

      def version
        @version ||= data_worksheet.name
      end

      def date_updated
        DateTime.strptime(version.split('_', 2).second, '%d%m%Y').to_date
      end

      def each
        data_worksheet.each(1) do |raw_row|
          yield LwinWine.from_row(Row.new(raw_row))
        end
      end

      private

      def valid_workbook?
        [
          @workbook.present?,
          @workbook.worksheets.size == 3,
          @workbook.worksheets.first.name == 'About_L-WIN'
        ].all?
      end

      def data_worksheet
        @data_worksheet ||= @workbook.worksheets.second
      end
    end
  end
end
