class Classification < ActiveRecord::Base
  has_many :wines, dependent: :destroy

  validates :designation, presence: true

  validates_uniqueness_of :classification, scope: :designation

  def self.paginated(page)
    order(:designation, :classification).page(page)
  end

  def title
    [ designation, classification ].compact.map(&:humanize).join(' - ')
  end
end
