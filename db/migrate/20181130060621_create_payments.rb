class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references  :user,index:true, foreign_key:true
      t.string     :customer_id, null:false
      t.string     :subscription_id
      t.string     :plan_id
      t.string     :last4
      t.string     :brand
      t.string     :exp_month
      t.string     :exp_year
      t.datetime   :expires_at
      t.timestamps
    end
  end
end
