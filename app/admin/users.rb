ActiveAdmin.register User do
  actions :all, except: [:new, :create, :destroy]

  index do
    column :id
    column :email
    column :name
    column '性別' do |user|
      user.userProfile.sex
    end
    column '勤務先' do |user|
      user.userProfile.work_place
    end
    column '職種' do |user|
      user.userProfile.job
    end
    column '専門分野' do |user|
      user.userProfile.specialized_field
    end
    column '勤務先の所在地' do |user|
      user.userProfile.location
    end
    column '職種' do |user|
      user.userProfile.job
    end
    column '生年月日' do |user|
      user.userProfile.birthday
    end
    column :pay_regi_status
    actions
  end
end
