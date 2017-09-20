module Icol
  require 'spec_helper'
  
  describe Notification do
    context 'association' do
      it { should have_many(:notify_steps) }
    end
  end
end
