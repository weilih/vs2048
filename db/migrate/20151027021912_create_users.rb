class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
