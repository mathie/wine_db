class LwinIdentifier < ActiveRecord::Base
  include Searchable

  enum status: [
    :live,
    :deleted,
    :combined
  ]

  belongs_to :wine

  validates :identifier, presence: true, uniqueness: true
  validates :status, presence: true
  validates :identifier_updated_at, presence: true
  validates :wine, presence: { unless: :deleted? }

  def self.paginated(page)
    order(:identifier).includes(:wine).page(page)
  end
end
