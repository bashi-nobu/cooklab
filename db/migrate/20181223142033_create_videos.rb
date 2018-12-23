class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.string :video_url, null: false
      t.text :introduction, null: false
      t.text :commentary, null: false
      t.integer :video_order, null: false
      t.string :thumbnail, null: false
      t.integer :price, default: 0
      t.integer :like_count, default: 0
      t.references :series, null: false, foreign_key: true
      t.timestamps
    end
  end
end
