class UnpNumberValidator < ActiveModel::EachValidator
  WEIGHT_COEFFS = [29, 23, 19, 17, 13, 7, 5, 3]
  CORRECTION = 11
  VALID_LENGTH = 9
  MAP_FIRST_LETTER = { 'A': 10, 'B': 11, 'C': 12, 'E': 14, 'H': 17, 'K': 20, 'M': 22,
    'А': 10, 'В': 11, 'С': 12, 'Е': 14, 'Н': 17, 'К': 20, 'М': 22}

  MAP_SECOND_LETTER = { 'A': 0, 'B': 1, 'C': 2, 'E': 3, 'H': 4, 'K': 5, 'M': 6, 'O': 7,
    'P': 9, 'T': 9, 'А': 0, 'В': 1, 'С': 2, 'Е': 3, 'Н': 4, 'К': 5, 'М': 6, 'О': 7,
    'Р': 9, 'Т': 9 }

  def validate_each(record, attribute, value)
    unless check_validity(record, value)
      record.errors[attribute] << (options[:message] || 'bad format')
    end
  end

  private

  def check_validity(record, value)
    check_length(value) && check_digits(record, value) && check_letters(record, value) &&
      check_control_sum(record, value)
  end

  def check_length(value)
    value.length == VALID_LENGTH
  end

  def check_digits(record, value)
    checked_value = record.payer_type == 'physical' ? value.last(7) : value
    !(checked_value =~ /^\d+/).nil?
  end

  def check_letters(record, value)
    if record.payer_type == 'physical'
      check_letter_in_keys_list(MAP_FIRST_LETTER, value[0]) &&
        check_letter_in_keys_list(MAP_SECOND_LETTER, value[1])
    else
      true
    end
  end

  def check_letter_in_keys_list(list, letter)
    list.stringify_keys!.keys.include?(letter)
  end

  def check_control_sum(record, value)
    array_value = value_to_array(value)
    array_value = map_letters_to_digits(array_value) if record.payer_type == 'physical'
    array_value.map!(&:to_i)

    control_sum(sum(array_value.first(8))) == array_value.last
  end

  def map_letters_to_digits(value)
    value[0] = MAP_FIRST_LETTER.stringify_keys![value[0]]
    value[1] = MAP_SECOND_LETTER.stringify_keys![value[1]]

    value
  end

  def sum(value)
    sum = 0
    value.each_with_index do |val, ind|
      sum += val * WEIGHT_COEFFS[ind]
    end

    sum
  end

  def value_to_array(value)
    value.split('')
  end

  def control_sum(sum)
    sum - CORRECTION * (sum/CORRECTION)
  end

end
