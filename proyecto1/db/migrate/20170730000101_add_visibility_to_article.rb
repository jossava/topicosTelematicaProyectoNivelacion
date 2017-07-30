class AddVisibilityToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :visibility, :string
  end
end
