class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges do |t|
      t.references  :user,  index: true, foreign_key: true
      t.references  :video, index: true, foreign_key: true
      t.timestamps
    end
  end
end
