class UnpValidator < ActiveModel::Validator

  def validate_each(record, attribute, value)
    p '*' * 20
  end

end
