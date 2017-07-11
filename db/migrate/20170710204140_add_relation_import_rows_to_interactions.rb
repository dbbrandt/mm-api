class AddRelationImportRowToInteractions < ActiveRecord::Migration[5.0]
  def change
    add_reference :interactions, :import_row, foreign_key: true
  end
end
