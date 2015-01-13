class Classification < ActiveRecord::Base
  has_many :wines, dependent: :destroy

  validates :classification, presence: true

  validates_uniqueness_of [:classification, :designation]
end
