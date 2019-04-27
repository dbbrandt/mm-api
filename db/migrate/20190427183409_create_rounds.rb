class CreateRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :rounds do |t|
      t.references :goal, foreign_key: true
      t.references :fae_user, foreign_key: true

      t.timestamps
    end
  end
end
