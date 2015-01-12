module Importers
  module Lwin
    class BaseWine < Wine
      define_attribute_methods :producer, :wine, :country, :region,
      :subregion, :colour, :type, :designation, :classification
    end
  end
end
