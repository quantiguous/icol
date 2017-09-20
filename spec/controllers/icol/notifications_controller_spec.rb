module Icol
  require 'spec_helper'
  
  describe NotificationsController do
    
    before(:each) do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      sign_in @user = Factory(:user)
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
      request.env["HTTP_REFERER"] = "/"
    end
    
    describe "GET index" do
      it "assigns all notifications as @notifications" do
        notification = Factory(:notification)
        get :index
        assigns(:records).should eq([notification])
      end
    end
    
    describe "GET show" do
      it "assigns the requested notification as @notification" do
        notification = Factory(:notification)
        get :show, {:id => notification.id}
        assigns(:notification).should eq(notification)
      end
    end
    
    describe "GET audit_steps" do
      it "assigns the steps of the requested notification" do
        notification1 = Factory(:notification)
        step1 = Factory(:notify_step, step_name: 'Validate', notification_id: notification1.id)
        step2 = Factory(:notify_step, step_name: 'Notify', notification_id: notification1.id)
        step3 = Factory(:notify_step, step_name: 'Valida', notification_id: notification1.id)
        
        get :audit_steps, {:id => notification1.id}
        assigns(:steps).should eq([step3, step2, step1])
        
        notification2 = Factory(:notification)
        get :audit_steps, {:id => notification2.id}
        assigns(:steps).should eq([])
      end
    end
  end
end
