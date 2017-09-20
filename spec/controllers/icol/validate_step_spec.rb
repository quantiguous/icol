module Icol
  require 'spec_helper'
  
  describe IcolValidateStepsController do
    
    before(:each) do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      sign_in @user = Factory(:user)
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
      request.env["HTTP_REFERER"] = "/"
    end
    
    describe "GET index" do
      it "assigns all validate_steps as @validate_steps" do
        validate_step = Factory(:icol_validate_step)
        get :index
        assigns(:records).should eq([validate_step])
      end
    end
    
    describe "GET show" do
      it "assigns the requested validate_step as @validate_step" do
        validate_step = Factory(:icol_validate_step)
        get :show, {:id => validate_step.id}
        assigns(:validate_step).should eq(validate_step)
      end
    end
  end
end
