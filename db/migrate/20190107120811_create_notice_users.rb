class CreateNoticeUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :notice_users do |t|
      t.references  :user,  index: true, foreign_key: true
      t.references  :notice, index: true, foreign_key: true
      t.timestamps
    end
  end
end
