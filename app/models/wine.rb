class Wine < ActiveRecord::Base
  include Searchable

  enum colour: [ :unknown_colour, :red, :rose, :white ]
  enum wine_type: [
    :unknown_wine_type,
    :armagnac,
    :cognac,
    :eaux_vie,
    :fortified,
    :fruit_liqueur,
    :gin,
    :grappa,
    :herb_liqueur,
    :rum,
    :sparkling,
    :spirit,
    :still,
    :sweet,
    :vodka,
    :whiskies
  ]

  belongs_to :producer
  belongs_to :location
  belongs_to :classification
  has_many :lwin_identifiers

  validates :name, presence: true, uniqueness: { scope: :producer_id }
  validates :colour, presence: true
  validates :wine_type, presence: true
  validates :location, presence: true

  def self.paginated(page)
    order(:name).page(page)
  end

  def canonical_identifier
    lwin_identifiers.live.take!
  end

  def combined_identifiers
    lwin_identifiers.combined
  end
end
