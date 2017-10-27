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

    if row["answer_type"].blank? or !(Interaction::TYPES.include?(row["answer_type"]))
      record.errors.add(:answer_type, ": #{row["answer_type"]} must be a valid type (#{Interaction::TYPES.to_s})")
    end

    if row["criterion1"].blank? or row["points1"].nil?
      record.errors.add(:criterion, ": At least one complete criterion (title and ponits) is required.")
    end

  end
end