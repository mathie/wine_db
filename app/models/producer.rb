class Producer < ActiveRecord::Base
  include Searchable

  has_many :wines, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.paginated(page)
    order(:name).page(page)
  end

  def number_of_wines
    wines.count
  end
end
