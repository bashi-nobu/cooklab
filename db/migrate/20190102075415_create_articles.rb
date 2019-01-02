class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :contents, null: false
      t.string :thumbnail, null: false
      t.integer :like_count, default: 0
      t.timestamps
    end
  end
end
