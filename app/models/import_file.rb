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
  def create_rows
    # Once rows are created from the json_date they cannot be recreated to avoid possible duplication.
    return if import_rows.size > 0
    rows = JSON.parse(json_data)
    ActiveRecord::Base.transaction do
      rows.each do |row|
        new_row = import_rows.create!(title: row["title"], json_data: row.to_json)
        puts new_row
      end
    end
  end

  def delete_rows
    return if import_rows.size == 0
    ActiveRecord::Base.transaction do
      import_rows.each do |row|
        row.destroy unless row.interaction
      end
    end
  end



end


