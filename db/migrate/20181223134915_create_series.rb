class CreateSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :series do |t|
      t.string :title, null: false
      t.string :introduction
      t.string :thumbnail
      t.integer :price, default: 0
      t.references :chef, null: false, foreign_key: true
      t.timestamps
    end
  end
end
