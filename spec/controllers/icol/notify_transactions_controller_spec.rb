module Icol
  require 'spec_helper'
  
  describe IcolNotifyTransactionsController do
  
    before(:each) do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      sign_in @user = Factory(:user)
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
      request.env["HTTP_REFERER"] = "/"
      request.env["CONFIG_ENVIRONMENT"] = "test"
    end
  
  
    describe "GET index" do
      it "assigns all icol_notify_transactions as @icol_notify_transactions" do
        notify_transaction = Factory(:notify_transaction)
        get :index
        assigns(:notify_transactions).should eq([notify_transaction])
      end
    end
  
    describe "GET show" do
      it "assigns the requested notify_transaction as @notify_transaction" do
        notify_transaction = Factory(:notify_transaction)
        get :show, {:id => notify_transaction.id}
        assigns(:notify_transaction).should eq(notify_transaction)
      end
    end
  
    describe "GET new" do
      it "assigns a new notify_transaction as @notify_transaction" do
        get :new
        assigns(:notify_transaction).should be_a_new(NotifyTransaction)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested notify_transaction as @notify_transaction" do
        @notify_transaction = Factory(:notify_transaction)
        get :edit, {:id => @notify_transaction.id}
        assigns(:notify_transaction).should eq(@notify_transaction)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new notify_transaction" do
          params = Factory.attributes_for(:notify_transaction)
          expect {
            post :create, {:notify_transaction => params}
          }.to change(NotifyTransaction.all, :count).by(1)
          flash[:alert].should  match(/Notify Transaction successfully created/)
          response.should be_redirect
        end
  
        it "assigns a newly created notify_transaction as @notify_transaction" do
          params = Factory.attributes_for(:notify_transaction)
          post :create, {:notify_transaction => params}
          assigns(:notify_transaction).should be_a(NotifyTransaction)
          assigns(:notify_transaction).should be_persisted
        end
  
        it "redirects to the icol_notify_transactions list" do
          params = Factory.attributes_for(:notify_transaction)
          post :create, {:notify_transaction => params}
          response.should redirect_to(icol_notify_transactions_url)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved notify_transaction as @notify_transaction" do
          params = Factory.attributes_for(:notify_transaction)
          params[:payment_status] = nil
          expect {
            post :create, {:notify_transaction => params}
          }.to change(NotifyTransaction.all, :count).by(0)
          assigns(:notify_transaction).should be_a(NotifyTransaction)
          assigns(:notify_transaction).should_not be_persisted
        end
  
        it "re-renders the 'new' template when show_errors is true" do
          params = Factory.attributes_for(:notify_transaction)
          params[:payment_status] = nil
          post :create, {:notify_transaction => params}
          response.should render_template("new")
        end
      end
    end
  
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested notify_transaction" do
          notify_transaction = Factory(:notify_transaction, :payment_status => "ABC")
          params = notify_transaction.attributes.slice(*notify_transaction.class.attribute_names)
          params[:payment_status] = "ABC"
          put :update, {:id => notify_transaction.id, :notify_transaction => params}
          notify_transaction.reload
          notify_transaction.payment_status.should == "ABC"
        end
  
        it "assigns the requested notify_transaction as @notify_transaction" do
          notify_transaction = Factory(:notify_transaction, :payment_status => "ABC")
          params = notify_transaction.attributes.slice(*notify_transaction.class.attribute_names)
          params[:payment_status] = "ABC"
          put :update, {:id => notify_transaction.to_param, :notify_transaction => params}
          assigns(:notify_transaction).should eq(notify_transaction)
        end
  
        it "redirects to the notify_transaction list" do
          notify_transaction = Factory(:notify_transaction, :payment_status => "ABC")
          params = notify_transaction.attributes.slice(*notify_transaction.class.attribute_names)
          params[:payment_status] = "ABC"
          put :update, {:id => notify_transaction.to_param, :notify_transaction => params}
          response.should redirect_to(icol_notify_transactions_url)
        end
      end
    end
  
    describe "destroy" do
      it "should destroy the notify_transaction" do 
        notify_transaction = Factory(:notify_transaction)
        expect {delete :destroy, {:id => notify_transaction.id}}.to change(NotifyTransaction, :count).by(-1)
        NotifyTransaction.find_by_trnsctn_nmbr(notify_transaction.id).should be_nil
      end
  
      it "redirects to the notify_transaction list" do
        notify_transaction = Factory(:notify_transaction)
        delete :destroy, {:id => notify_transaction.id}
        response.should redirect_to(icol_notify_transactions_url)
      end
    end
  
  end
end
