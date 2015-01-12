module Importers
  module Lwin
    class CombinedWine < BaseWine
      define_attribute_methods :reference

      validates :reference, presence: true
    end
  end
end
