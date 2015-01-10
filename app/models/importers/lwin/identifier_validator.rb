module Importers
  module Lwin
    # L-WIN identifiers are 7-digit 'numbers'.
    class IdentifierValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add attribute, "isn't a valid L-WIN identifier" unless value =~ /^[0-9]{7}$/
      end
    end
  end
end