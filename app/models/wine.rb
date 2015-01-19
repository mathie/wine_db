class Wine < ActiveRecord::Base
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

  def self.search(query)
    query_function = sanitize_sql_array(["plainto_tsquery('english', ?)", query])
    conditions = "search_vector @@ #{query_function}"
    order = "ts_rank_cd(search_vector, #{query_function}) DESC"

    where(conditions).order(order)
  end

  def canonical_identifier
    lwin_identifiers.live.take!
  end

  def combined_identifiers
    lwin_identifiers.combined
  end
end
