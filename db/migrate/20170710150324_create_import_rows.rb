class CreateImportRows < ActiveRecord::Migration[5.0]
  def change
    create_table :import_rows do |t|
      t.string :title
      t.text :json_data
      t.references :import_file, foreign_key: true

      t.timestamps
    end
  end
end
