class AddStatusToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :status, :integer, default: 0
  end
end
