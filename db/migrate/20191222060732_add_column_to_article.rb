class AddColumnToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :top_slide, :boolean, after: :chef_id, default: false, null: false
  end
end
