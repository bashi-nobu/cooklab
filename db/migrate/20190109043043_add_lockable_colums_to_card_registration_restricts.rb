class AddLockableColumsToCardRegistrationRestricts < ActiveRecord::Migration[5.2]
  def change
    add_column :card_registration_restricts, :total_error_count, :integer, default: 0, null: false
  end
end
