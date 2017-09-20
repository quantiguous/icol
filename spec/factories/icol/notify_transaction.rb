module Icol
  FactoryGirl.define do
    factory :notify_transaction, class: 'Icol::NotifyTransaction' do
      template_id 1
      compny_id 1
      comapny_name  "hooda"
      trnsctn_mode "nef"
      sequence(:trnsctn_nmbr) { |n| n}
      crtd_date_time "2017-09-05 02:23:35"
      payment_status "pas"
      template_data "Template Data"
    end
  end
end