class CreateRoundResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :round_responses do |t|
      t.references :round, foreign_key: true
      t.references :interaction, foreign_key: true
      t.text :answer
      t.float :score
      t.boolean :is_correct
      t.boolean :review_is_correct

      t.timestamps
    end
  end
end
