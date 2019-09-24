FactoryGirl.define do
  factory :invoice do
    identifier "MyString"
    receipt_number "MyString"
    currency "MyString"
    due_date "MyString"
    description "MyText"
    amount_due "9.99"
    customer nil
    business nil
  end
end
