class Producer < ActiveRecord::Base
  has_many :wines, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
