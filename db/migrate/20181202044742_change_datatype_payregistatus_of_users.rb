class ChangeDatatypePayregistatusOfUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :pay_regi_status, :integer, defalt: 0, null: false
  end
end
