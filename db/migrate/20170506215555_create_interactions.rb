class CreateInteractions < ActiveRecord::Migration[5.0]
  def change
    create_table :interactions do |t|
      t.string :title
      t.string :answer_type
      t.references :goal, foreign_key: true

      t.timestamps
    end
  end
end
