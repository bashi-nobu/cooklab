class AddColumnCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :charges, :price, :integer, null:false, after: :video_id
    add_column :charges, :product_id, :string, null:false, after: :price
  end
end
