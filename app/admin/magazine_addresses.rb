ActiveAdmin.register MagazineAddress do

  index do
    column :id
    column :zipcode
    column :pref
    column :city_address
    column :building
    column '会員種類' do |ma|
      ma.user.pay_regi_status
    end
    actions
  end
end