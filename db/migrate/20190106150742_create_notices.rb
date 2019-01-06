class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.string :title, null: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
