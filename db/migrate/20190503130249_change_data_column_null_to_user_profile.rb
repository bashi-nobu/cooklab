class ChangeDataColumnNullToUserProfile < ActiveRecord::Migration[5.2]
  def change
    change_column :user_profiles, :sex, :integer, null: true
    change_column :user_profiles, :work_place, :integer, null: true
    change_column :user_profiles, :job, :integer, null: true
    change_column :user_profiles, :specialized_field, :integer, null: true
    change_column :user_profiles, :location, :integer, null: true
  end
end