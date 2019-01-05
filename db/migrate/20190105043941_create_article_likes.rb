class CreateArticleLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :article_likes do |t|
      t.integer :article_id, index: true
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
