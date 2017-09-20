module Icol
  # Read about factories at http://github.com/thoughtbot/factory_girl
  
  FactoryGirl.define do
    factory :notify_step, class: 'Icol::NotifyStep' do
      notification_id { Factory(:notification).id}
      step_name "Notify"
      attempt_no 1
      status_code "Success"
      req_timestamp "2017-01-01"
      req_bitstream "<xml/>"
    end
  end

end
