class Location < ActiveRecord::Base
  include Searchable

  belongs_to :parent, class_name: 'Location'
  has_many :children, class_name: 'Location', foreign_key: 'parent_id', dependent: :destroy
  has_many :wines, dependent: :destroy

  validates :name, presence: true

  validates_uniqueness_of :name, scope: :parent_id

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

  def self.paginated(page)
    order(:name).page(page)
  end

  def title
    if parent.present?
      [ parent.title, name ].compact.join(' - ')
    else
      name
    end
  end

  # FIXME: There's a more efficient way to do this in SQL.
  def number_of_wines
    wines.count + children.inject(0) { |sum, child| child.number_of_wines + sum }
  end
end
