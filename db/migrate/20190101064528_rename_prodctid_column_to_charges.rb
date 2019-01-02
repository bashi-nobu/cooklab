class RenameProdctidColumnToCharges < ActiveRecord::Migration[5.2]
  def change
    rename_column :charges, :product_id, :payjp_charge_id
  end
end
