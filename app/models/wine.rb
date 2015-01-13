class Wine < ActiveRecord::Base
  enum colour: [ :unknown, :red, :rose, :white ]
  enum wine_type: [
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

  validates :name, presence: true
  validates :colour, presence: true
  validates :wine_type, presence: true
  validates :location, presence: true
end
