class Classification < ActiveRecord::Base
  include Searchable

  has_many :wines, dependent: :destroy

  validates :designation, presence: true

  validates_uniqueness_of :classification, scope: :designation

  def self.paginated(page)
    order(:designation, :classification).page(page)
  end

  def title
    [
      designation,
      classification.try(:humanize).try(:titleize)
    ].select(&:present?).join(' - ')
  end
end
