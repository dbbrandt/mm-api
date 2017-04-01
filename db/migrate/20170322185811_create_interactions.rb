class CreateInteractions < ActiveRecord::Migration[5.0]
  def change
    create_table :interactions do |t|
      t.string :name
      t.string :type
      t.references :goal, foreign_key: true

      t.timestamps
    end
  end
end
