class ChangeDataBirthdayToUserProfile < ActiveRecord::Migration[5.2]
  def change
    change_column :user_profiles, :birthday, :date, null: true
  end
end
