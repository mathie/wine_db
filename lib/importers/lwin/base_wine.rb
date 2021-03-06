require 'importers/lwin/lwin_wine'

module Importers
  module Lwin
    class BaseWine < LwinWine
      define_attribute_methods :producer, :wine, :country, :region,
      :subregion, :colour, :type, :designation, :classification
    end
  end
end
