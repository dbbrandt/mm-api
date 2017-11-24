class ImportFile < ApplicationRecord
  include Fae::BaseModelConcern

  def fae_display_field
    title
  end

  validates_presence_of :title
  validates_presence_of :json_data

  default_scope { order(:title)}

  belongs_to :goal
  has_many :import_rows, dependent: :destroy

  # Create all the import_rows from the json_data
  # Return true if rows were created
  def create_rows
    # Once rows are created from the json_date they cannot be recreated to avoid possible duplication.
    return false if import_rows.size > 0
    rows = JSON.parse(json_data)
    # account for title row
    row_count = 2
    import_errors = []
    ActiveRecord::Base.transaction do
      rows.each do |row|
        new_row = ImportRow.new(title: row["title"], json_data: row.to_json)
        if new_row.valid?
          import_rows.create!(title: row["title"], json_data: row.to_json)
        else
          import_errors << { "Row #{row_count}": new_row.errors.full_messages }
        end
        row_count += 1
      end
    end
    reload
    return import_errors
  end

  # Delete all rows not associated with an interaction
  # Return true if all rows deleted.
  def delete_rows
    return true if import_rows.size == 0
    ActiveRecord::Base.transaction do
      import_rows.each do |row|
        row.destroy unless row.interaction
      end
    end
    reload
    return import_rows.size == 0
  end



end


