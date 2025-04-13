class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.text :description
      t.boolean :done, null: false, default: false
    end
  end
end
