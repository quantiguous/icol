module Icol
  # Read about factories at http://github.com/thoughtbot/factory_girl
  
  FactoryGirl.define do
    factory :notification, class: 'Icol::Notification' do
      app_code 'APP12'
      sequence(:customer_code) {|n| "%03i" % "#{n}"}
      status_code 'Success'
      company_name 'HOODA'
      sequence(:txn_number) {|n| n}
      txn_mode 'NEFT'
      txn_date Time.now
      payment_status "PASS"
      template_data "Template"
      company_id 1
      template_id 1
      pending_approval 'N'
    end
  end
end
