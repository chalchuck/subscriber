FactoryGirl.define do
  factory :coupon do
    subscription nil
    user nil
    business nil
    valid false
    times_redeemed 1
    redeem_by "2016-11-03 03:33:02"
    metadata ""
    duration "MyString"
    currency "MyString"
    percent_off "9.99"
    amount_off "9.99"
    identifier "MyString"
  end
end
