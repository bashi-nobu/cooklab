ActiveAdmin.register Series do
  permit_params :title, :introduction, :thumbnail, :price, :chef_id

  index do
    column :id
    column :title
    column :price
    column :chef
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :introduction
      f.input :thumbnail
      f.input :price
      f.input :chef_id, as: :select, collection: Chef.all.map { |c| [c.name, c.id] }
    end
    f.actions
  end
end
