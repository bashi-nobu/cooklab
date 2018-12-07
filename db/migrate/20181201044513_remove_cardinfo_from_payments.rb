class RemoveCardinfoFromPayments < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :last4, :string
    remove_column :payments, :brand, :string
    remove_column :payments, :exp_month, :string
    remove_column :payments, :exp_year, :string
  end
end
