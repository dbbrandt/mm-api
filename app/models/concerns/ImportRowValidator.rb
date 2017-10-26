class ImportRowValidator < ActiveModel::Validator
  def validate(record)

    if record.title.blank?
      record.errors.add(:title, "can't be blank")
    end

    json = record.json_data

    if json.blank?
      record.errors.add(:json_data, "can't be blank")
      return
    end

    row = JSON.parse(json)

    if row["prompt"].blank?
      record.errors.add(:prompt, "can't be blank.")
    end

    if row["criterion1"].blank? or row["copy1"].blank? or row["points1"].nil?
      record.errors.add(:criterion, ": At least one complete criterion is required.")
    end

    if row["points1"].to_i+row["points2"].to_i+row["points3"].to_i+row["points4"].to_i == 0
      record.errors.add(:points, ": At least one criterion with points is required")
    end

  end
end