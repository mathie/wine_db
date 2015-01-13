class LwinIdentifier < ActiveRecord::Base
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
end
