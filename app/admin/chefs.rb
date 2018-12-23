ActiveAdmin.register Chef do
  permit_params :name, :phonetic, :introduction, :attributes, :biography, :chef_avatar
end
