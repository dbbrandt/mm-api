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
    logger.info "Import File: creating #{rows.count} import rows."
    # account for title row
    row_count = 2
    import_errors = []
    import_rows = []
    rows.each do |row|
      new_row = ImportRow.new(title: row["title"], json_data: row.to_json)
      logger.info "Create Rows: creating row #{row_count} with title #{new_row.title}."
      if new_row.valid?
        import_rows << new_row
      else
        logger.error "Create Rows: error on row #{row_count}: #{new_row.errors.full_messages}."
        import_errors << { "Row #{row_count}": new_row.errors.full_messages.join(",") }
    end
      row_count += 1
    end
    import_errors = validate_rows(import_errors,import_rows)
    logger.error "Create Rows: row creation aborted. #{import_errors.count} validation errors."
    if import_errors.empty?
      save_rows(import_rows)
    else
      import_errors << { "Rows #{row_count-1}": "Import rows not created. #{import_errors.count} validation errors." }
    end
    reload
    return import_errors
  end

  # Perform cross row validations like custom uniqueness constraints
  def validate_rows(errors, rows)
    errors = errors
    titles = {}
    title = rows.each_with_index  do |row, index|
      titles[row.title] = titles[row.title].to_i + 1
      errors << { "Row #{index + 2}": "title must be unique. Duplicate value: #{row.title}" } if titles[row.title] > 1
    end
    # Resort the errors which got appeneded. The format of the errors requires conversion from a symbol to integer
    errors.sort_by { |hsh| hsh.keys[0].to_s.sub("Row ","").to_i }
  end

  def save_rows(rows)
    rows.each_with_index do |row, index|
      logger.debug "Save Rows: Saving. #{index} rows: #{row.title}."
      import_rows.create!(title: row.title, json_data: row.json_data)
    end
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


