class Location < ActiveRecord::Base
  belongs_to :parent, class_name: 'Location'
  has_many :children, class_name: 'Location', foreign_key: 'parent_id', dependent: :destroy
  has_many :wines, dependent: :destroy

  validates :name, presence: true

  validates_uniqueness_of [:parent_id, :name]

  def self.find_or_create_by_tuple(country, region = nil, subregion = nil)
    country = find_or_create_by(name: country, parent_id: nil)
    if region.present?
      region = country.children.find_or_create_by(name: region)
      if subregion.present?
        subregion = region.children.find_or_create_by(name: subregion)
      else
        region
      end
    else
      country
    end
  end
end
