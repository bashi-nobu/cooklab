class AddPayregistatusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pay_regi_status, :integer, defalt: 0
  end
end
