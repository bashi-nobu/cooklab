class ChangeDatatypePayregistatus2OfUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :pay_regi_status, :integer, default: 0, null: false
  end
end
