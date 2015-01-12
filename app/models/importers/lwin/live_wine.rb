module Importers
  module Lwin
    class LiveWine < BaseWine
      validates :producer, presence: true
    end
  end
end
