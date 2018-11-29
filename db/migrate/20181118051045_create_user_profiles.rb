class CreateUserProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_profiles do |t|
      t.references  :user,index:true, foreign_key:true
      t.integer     :sex,null:false
      t.integer     :work_place,null:false
      t.integer     :job,null:false
      t.integer     :specialized_field,null:false
      t.integer     :location,null:false
      t.date     :birthday,null:false
      t.timestamps
    end
  end
end
