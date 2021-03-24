class CreateBook < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :description
      t.float :price, null: false, default: 0.0

      t.timestamps
    end
  end
end
