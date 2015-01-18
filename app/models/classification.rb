class Classification < ActiveRecord::Base
  has_many :wines, dependent: :destroy

  validates :designation, presence: true

  validates_uniqueness_of :classification, scope: :designation
end
