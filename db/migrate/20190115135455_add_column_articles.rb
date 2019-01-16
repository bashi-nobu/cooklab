class AddColumnArticles < ActiveRecord::Migration[5.2]
  def change
     add_reference :articles, :chef, foreign_key: true, after: :like_count
  end
end
