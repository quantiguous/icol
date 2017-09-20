module Icol
  require 'spec_helper'
  
  describe NotifyTransaction, type: :model do
    
    context 'validation' do
      [:template_id, :compny_id, :comapny_name, :trnsctn_mode, :trnsctn_nmbr, :payment_status,:template_data].each do |att|
        it { should validate_presence_of(att) }
      end
  
      it do
        [:payment_status, :trnsctn_mode].each do |att|
          should validate_length_of(att).is_at_most(3)
        end
        [:template_data].each do |att|
          should validate_length_of(att).is_at_most(1000)
        end
        [:comapny_name].each do |att|
          should validate_length_of(att).is_at_most(100)
        end
      end
  
      it {should validate_numericality_of(:trnsctn_nmbr)}
      it {should validate_numericality_of(:compny_id)}
      it {should validate_numericality_of(:trnsctn_nmbr)}
  
      
      it "should validate uniqueness of transfer_unique_no" do
        notify_transaction = Factory(:notify_transaction)
        should validate_uniqueness_of(:trnsctn_nmbr)
      end
    end  
  end
end
