class PasswordChangesDetector
  def initialize(user)
    @user = user
    @errors = @user.errors
    @current_min_changes = []
  end

  def result
    errors.full_messages.each do |error|
      case error
      when 'Password is too short (minimum is 10 characters)'
        get_short_change_count
      when 'Password is too long (maximum is 16 characters)'
        get_long_change_count
      when 'Password should have atleast one number'
        get_atleast_one_number_change_count
      when 'Password should have atleast one lower case character'
        get_atleast_one_lower_char_change_count
      when 'Password should have atleast one upper case character'
        get_atleast_one_upper_char_change_count
      when 'Password has duplicate characters'
        get_duplicate_characters_change_count
      else
        1
      end
    end
    
    return_min_error_count
  end

  private

  def get_short_change_count
    short_nums_of_chars = User.validators_on(:password)[1].options[:minimum] - user.password.length
    current_min_changes.push({ name: 'short_length', count: short_nums_of_chars })
  end

  def get_long_change_count
    long_nums_of_chars = user.password.length - User.validators_on(:password)[1].options[:maximum]
    current_min_changes.push({ name: 'long_length', count: long_nums_of_chars })
  end

  def get_atleast_one_number_change_count
    current_min_changes.push({ name: 'one_number', count: 1 })
  end

  def get_atleast_one_lower_char_change_count
    current_min_changes.push({ name: 'one_lower_char', count: 1 })
  end

  def get_atleast_one_upper_char_change_count
    current_min_changes.push({ name: 'one_upper_char', count: 1 })
  end

  def get_duplicate_characters_change_count
    # duplicates = user.password.chars.group_by { |char| char }.select { |key, value| value.size > 1 }
    # total_changes = 0
    # duplicates.each do |item, value|
    #   binding.pry
    #   total_changes += 2 if value.size == 3
    #   total_changes += 1 if value.size == 2
    # end
    # binding.pry
    # current_min_changes.push({
    #   name: 'duplicates',
    #   count: total_changes
    # })
  end

  def return_min_error_count
    current_min_changes.map { |change| change[:count] }.min
  end

  attr_reader :user, :errors
  attr_accessor :current_min_changes
end
