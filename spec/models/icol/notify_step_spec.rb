module Icol
  require 'spec_helper'
  
  describe NotifyStep, type: :model do
  
    context 'association' do
      it { should belong_to(:notification) }
    end
  end
end
