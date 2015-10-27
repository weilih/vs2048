class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :players, array: true, default: []
      t.integer :state, array: true
      t.integer :winner
      t.timestamps null: false
    end
  end
end
