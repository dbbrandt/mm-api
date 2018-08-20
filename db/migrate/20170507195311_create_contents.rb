class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :content_type
      t.text :description
      t.text :copy
      t.float :score
      t.text :descriptor
      t.references :interactions, foreign_key: true

      t.timestamps
    end
  end
end
