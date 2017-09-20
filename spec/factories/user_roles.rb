
FactoryGirl.define do
  factory :user_role do
    user_id {Factory(:user).id}
    role_id {Factory(:role).id}
    approval_status 'A'
  end
end
