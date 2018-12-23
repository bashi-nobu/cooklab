class AddColumnChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :phonetic, :string, null: false, after: :name
  end
end
