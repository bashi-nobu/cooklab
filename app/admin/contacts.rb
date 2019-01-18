ActiveAdmin.register Contact do
  actions :all, except: [:new, :create, :destroy]

end
