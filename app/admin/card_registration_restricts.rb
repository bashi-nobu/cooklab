ActiveAdmin.register CardRegistrationRestrict do
  actions :all, except: [:new, :create]

  index do
    column :user_id
    column :user
    column :error_count
    column :total_error_count
    column :locked_at
    actions
  end
end
