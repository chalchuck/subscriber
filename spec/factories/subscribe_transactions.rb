FactoryGirl.define do
  factory :subscribe_transaction do
    origin "MyString"
    msisdn "MyString"
    sender "MyString"
    amount "9.99"
    trans_amount "9.99"
    trans_id "MyString"
    bill_ref_number "MyString"
    trans_time "2016-10-24 04:07:33"
    raw_transaction ""
    business nil
    customer nil
    invoice nil
    subscription nil
  end
end
