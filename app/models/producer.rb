class Producer < ActiveRecord::Base
  has_many :wines, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.paginated(page)
    order(:name).page(page)
  end
end
