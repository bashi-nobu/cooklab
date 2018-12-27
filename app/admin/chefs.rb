ActiveAdmin.register Chef do
  permit_params :name, :phonetic, :introduction, :biography, :chef_avatar

  index do
    column :id
    column :name
    column :phonetic
    actions
  end
end
