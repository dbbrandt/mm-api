class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string :type
      t.string :description
      t.string :image_url
      t.string :copy
      t.float :score
      t.string :descriptor
      t.references :interaction, foreign_key: true

      t.timestamps
    end
  end
end
