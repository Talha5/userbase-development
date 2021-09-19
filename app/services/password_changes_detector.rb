class PasswordChangesDetector
  MIN_ALLOWED_REPEATING_CHARS_LIMIT = 2

  def initialize(user)
    @user = user
    @errors = @user.errors
    @current_min_changes = []
  end

  def result
    errors.full_messages.each do |error|
      case error
      when 'Password is too short (minimum is 10 characters)'
        calculate_short_change_count
      when 'Password is too long (maximum is 16 characters)'
        calculate_long_change_count
      when 'Password should have atleast one number'
        calculate_atleast_one_number_change_count
      when 'Password should have atleast one lower case character'
        calculate_atleast_one_lower_char_change_count
      when 'Password should have atleast one upper case character'
        calculate_atleast_one_upper_char_change_count
      when 'Password has duplicate characters'
        calculate_duplicate_characters_change_count
      end
    end

    return_min_error_count
  end

  private

  def calculate_short_change_count
    short_nums_of_chars = User.validators_on(:password)[1].options[:minimum] - user.password.length
    current_min_changes.push({ name: 'short_length', count: short_nums_of_chars })
  end

  def calculate_long_change_count
    long_nums_of_chars = user.password.length - User.validators_on(:password)[1].options[:maximum]
    current_min_changes.push({ name: 'long_length', count: long_nums_of_chars })
  end

  def calculate_atleast_one_number_change_count
    current_min_changes.push({ name: 'one_number', count: 1 })
  end

  def calculate_atleast_one_lower_char_change_count
    current_min_changes.push({ name: 'one_lower_char', count: 1 })
  end

  def calculate_atleast_one_upper_char_change_count
    current_min_changes.push({ name: 'one_upper_char', count: 1 })
  end

  def calculate_duplicate_characters_change_count
    chars_list = user.password.gsub(/(.)(\1)*/).to_a
    repeating_chars = chars_list.select { |item| item.length > 2 }
    total_changes = repeating_chars.map do |r_c|
      r_c.length - MIN_ALLOWED_REPEATING_CHARS_LIMIT
    end
    current_min_changes.push({ name: 'duplicate_characters', count: total_changes.length })
  end

  def return_min_error_count
    current_min_changes.map { |change| change[:count] }.min
  end

  attr_reader :user, :errors
  attr_accessor :current_min_changes
end
