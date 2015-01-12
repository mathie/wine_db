class Classification < ActiveRecord::Base
  validates :classification, presence: true

  validates_uniqueness_of [:classification, :designation]
end
