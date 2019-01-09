class CreateCardRegistrationRestricts < ActiveRecord::Migration[5.2]
  def change
    create_table :card_registration_restricts do |t|
      t.references  :user,  index: true, foreign_key: true
      t.integer  :error_count, default: 0, null: false
      t.datetime  :locked_at
    end
  end
end
