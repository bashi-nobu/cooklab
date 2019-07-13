class CreateMagazineAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :magazine_addresses do |t|
      t.references  :user,  index: true, foreign_key: true
      t.string      :address, null: false
      t.integer     :zipcode, null: false
      t.string      :pref, null: false
      t.string      :city_address, null: false
      t.string      :building
      t.timestamps
    end
  end
end
