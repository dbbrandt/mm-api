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

    begin
      row = JSON.parse(json)
    rescue JSON::ParserError
      record.errors.add(:json_data, 'invalid json - parse error')
      return
    end

    if row["prompt"].blank?
      record.errors.add(:prompt, "can't be blank.")
    end

    if row["answer_type"].blank? or !(Interaction::TYPES.include?(row["answer_type"]))
      record.errors.add(:answer_type, "must be a valid type (#{Interaction::TYPES.to_s})")
    end

    if row["criterion1"].blank? or row["points1"].nil?
      record.errors.add(:criterion, ": At least one complete criterion (criterion1 and points1) is required.")
    end

    total_points = row["points1"].to_i + row["points2"].to_i + row[:point3].to_i + row[:points4].to_i
    if total_points == 0
      record.errors.add(:points, ": At least one criterion is required to have points.")
    end

  end
end