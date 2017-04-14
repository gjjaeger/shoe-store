class CreateStoresBrands < ActiveRecord::Migration[5.0]
  def change
    create_table(:stores_brands) do |t|
      t.column(:store_id, :integer)
      t.column(:brand_id, :integer)
      t.timestamps()
    end
  end
end
