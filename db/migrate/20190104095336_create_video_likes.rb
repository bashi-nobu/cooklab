class CreateVideoLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :video_likes do |t|
      t.integer :video_id, index: true
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
