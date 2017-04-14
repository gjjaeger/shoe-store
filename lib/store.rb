class Store < ActiveRecord::Base
  has_many :stores_brands, dependent: :destroy
  has_many :brands, through: :stores_brands
  has_many :ratings

  validates(:name, :presence => true)
  validates(:address, :presence => true)

  before_save(:capitalize_name)

  private
    define_method(:capitalize_name) do
      self.name=(name().capitalize())
    end
    
end
