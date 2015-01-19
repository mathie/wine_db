require 'importers/lwin/lwin_wine'

module Importers
  module Lwin
    class DeletedWine < LwinWine
      def self.from_row(row)
        new(
          identifier:   row.identifier,
          date_updated: row.date_updated
        )
      end
    end
  end
end
