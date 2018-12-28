class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :food, null: false
      t.string :amount, null: false
      t.references :video, null: false, foreign_key: true
    end
  end
end
