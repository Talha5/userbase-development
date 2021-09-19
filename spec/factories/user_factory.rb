FactoryBot.define do
  factory :user do
    name { 'John' }
    password  { 'QPFJWz1343439' }

    trait :with_wrong_min_password_length do
      password { Faker::Alphanumeric.alpha(number: 5) }
    end

    trait :with_wrong_max_password_length do
      password { Faker::Alphanumeric.alpha(number: 19) }
    end

    trait :without_atleast_one_number_password do
      password { Faker::Alphanumeric.alpha(number: 12) }
    end

    trait :without_atleast_one_lower_letter_password do
      password { 'k1jhkjahksdhasd'.upcase! }
    end

    trait :without_atleast_one_upper_letter_password do
      password { 'k1jhkjahksdhasd' }
    end

    trait :with_repeating_chars_password do
      password { 'fk1swodsAAA' }
    end
  end
end
