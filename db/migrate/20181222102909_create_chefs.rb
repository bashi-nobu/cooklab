class CreateChefs < ActiveRecord::Migration[5.2]
  def change
    create_table :chefs do |t|
      t.string :name, null: false, index: true
      t.string :introduction, null: false
      t.text :biography, null: false
      t.string :chef_avatar
      t.timestamps
    end
  end
end
