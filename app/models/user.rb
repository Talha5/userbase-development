require 'csv'

class User < ApplicationRecord
  PASSWORD_REPEATING_CHARS_REQUIREMENTS = /(.)\1{2,}/
  PASSWORD_ATLEAST_ONE_NUMBER_REQUIREMENTS = /\d+/
  PASSWORD_ATLEAST_ONE_LOWER_LETTER_REQUIREMENTS = /[a-z]+/
  PASSWORD_ATLEAST_ONE_UPPER_LETTER_REQUIREMENTS = /[A-Z]+/

  validates_presence_of :name
  validates_presence_of :password

  validates :password, length: { minimum: 10, maximum: 16 }
  validate :custom_password_validation, if: -> { password.present? }

  def custom_password_validation
    atleast_one_number
    atleast_one_lower_character
    atleast_one_upper_character
    repeating_characters
  end

  # FIXME: use internationalization to avoid same strings all over the app.
  def atleast_one_number
    errors.add(:base, 'Password should have atleast one number') unless password.match(PASSWORD_ATLEAST_ONE_NUMBER_REQUIREMENTS).present?
  end

  def atleast_one_lower_character
    errors.add(:base, 'Password should have atleast one lower case character') unless password.match(PASSWORD_ATLEAST_ONE_LOWER_LETTER_REQUIREMENTS).present?
  end

  def atleast_one_upper_character
    errors.add(:base, 'Password should have atleast one upper case character') unless password.match(PASSWORD_ATLEAST_ONE_UPPER_LETTER_REQUIREMENTS).present?
  end

  def repeating_characters
    errors.add(:base, 'Password has duplicate characters') if password.match(PASSWORD_REPEATING_CHARS_REQUIREMENTS).present?
  end

  def self.import(file)
    users = []
    changes = []
    CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|
      user = User.new(name: row[0], password: row[1])
      users.push(user)
    end
    users.each do |user|
      user.save && changes.push("#{user.name} was successfully saved.") && next if user.valid?
      minimum_changes_required_count = PasswordChangesDetector.new(user)
      changes.push("Change #{minimum_changes_required_count.result} of #{user.name} password")
    end
    changes
    # use something more performant eg: active-record-import for efficient data imports into database.
  end
end
