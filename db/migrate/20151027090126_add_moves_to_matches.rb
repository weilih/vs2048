class AddMovesToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :moves, :integer, default: 0
  end
end
