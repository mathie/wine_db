module Importers
  module Lwin
    class LiveWine < BaseWine
      validates :producer, presence: true

      def self.from_row(row)
        new(
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
      end
    end
  end
end
