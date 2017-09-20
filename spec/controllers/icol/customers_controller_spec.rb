module Icol
  require 'spec_helper'
  
  describe CustomersController do    

    before(:each) do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      sign_in @user = Factory(:user)
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
      request.env["HTTP_REFERER"] = "/"
    end
    
    describe "GET new" do
      it "assigns a new customer as @customer" do
        get :new
        assigns(:customer).should be_a_new(Customer)
      end
    end
  
    describe "GET show" do
      it "assigns the requested customer as @customer" do
        customer = Factory(:customer)
        get :show, {:id => customer.id}
        assigns(:customer).should eq(customer)
      end
    end
    
    describe "GET index" do
      it "assigns all icol_customers as @icol_customers" do
        customer = Factory(:customer, :approval_status => 'A')
        get :index
        assigns(:records).should eq([customer])
      end
      
      it "assigns all unapproved icol_customers as @icol_customers when approval_status is passed" do
        customer = Factory(:customer, :approval_status => 'U')
        get :index, :approval_status => 'U'
        assigns(:records).should eq([customer])
      end
    end
    
    describe "GET edit" do
      it "assigns the requested customer as @customer" do
        customer = Factory(:customer, :approval_status => 'A')
        get :edit, {:id => customer.id}
        assigns(:customer).should eq(customer)
      end
      
      it "assigns the requested customer with status 'A' as @customer" do
        customer = Factory(:customer,:approval_status => 'A')
        get :edit, {:id => customer.id}
        assigns(:customer).should eq(customer)
      end
  
      it "assigns the new customer with requested customer params when status 'A' as @customer" do
        customer = Factory(:customer,:approval_status => 'A')
        params = (customer.attributes).merge({:approved_id => customer.id,:approved_version => customer.lock_version})
        get :edit, {:id => customer.id}
        assigns(:customer).should eq(Customer.new(params))
      end
    end
    
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested customer" do
          customer = Factory(:customer, :notify_url => "http://localhost")
          params = customer.attributes.slice(*customer.class.attribute_names)
          params[:notify_url] = "https://www.google.com"
          put :update, {:id => customer.id, :customer => params}
          customer.reload
          customer.notify_url.should == "https://www.google.com"
        end
  
        it "assigns the requested customer as @customer" do
          customer = Factory(:customer, :notify_url => "http://localhost")
          params = customer.attributes.slice(*customer.class.attribute_names)
          params[:notify_url] = "https://www.google.com"
          put :update, {:id => customer.to_param, :customer => params}
          assigns(:customer).should eq(customer)
        end
  
        it "redirects to the customer" do
          customer = Factory(:customer, :notify_url => "http://localhost")
          params = customer.attributes.slice(*customer.class.attribute_names)
          params[:notify_url] = "https://www.google.com"
          put :update, {:id => customer.to_param, :customer => params}
          response.should redirect_to(customer)
        end
  
        it "should raise error when tried to update at same time by many" do
          customer = Factory(:customer, :notify_url => "http://localhost")
          params = customer.attributes.slice(*customer.class.attribute_names)
          params[:notify_url] = "https://www.google.com"
          icol_customer2 = customer
          put :update, {:id => customer.id, :customer => params}
          customer.reload
          customer.notify_url.should == "https://www.google.com"
          params[:notify_url] = "https://www.yahoo.com"
          put :update, {:id => icol_customer2.id, :customer => params}
          customer.reload
          customer.notify_url.should == "https://www.google.com"
          flash[:alert].should  match(/Someone edited the customer the same time you did. Please re-apply your changes to the customer/)
        end
      end
  
      describe "with invalid params" do
        it "assigns the customer as @customer" do
          customer = Factory(:customer)
          params = customer.attributes.slice(*customer.class.attribute_names)
          params[:app_code] = nil
          put :update, {:id => customer.to_param, :customer => params}
          assigns(:customer).should eq(customer)
          customer.reload
          params[:app_code] = nil
        end
  
        it "re-renders the 'edit' template when show_errors is true" do
          customer = Factory(:customer)
          params = customer.attributes.slice(*customer.class.attribute_names)
          params[:http_username] = 'abc'
          params[:http_password] = nil
          put :update, {:id => customer.id, :customer => params, :show_errors => "true"}
          response.should render_template("edit")
        end
      end
    end
    
    describe "POST create" do
      describe "with valid params" do
        it "creates a new customer" do
          params = Factory.attributes_for(:customer)
          expect {
            post :create, {:customer => params}
          }.to change(Customer.unscoped, :count).by(1)
          flash[:alert].should  match(/Customer successfully created and is pending for approval/)
          response.should be_redirect
        end
  
        it "assigns a newly created customer as @customer" do
          params = Factory.attributes_for(:customer)
          post :create, {:customer => params}
          assigns(:customer).should be_a(Customer)
          assigns(:customer).should be_persisted
        end
  
        it "redirects to the created customer" do
          params = Factory.attributes_for(:customer)
          post :create, {:customer => params}
          response.should redirect_to(Customer.unscoped.last)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved customer as @customer" do
          params = Factory.attributes_for(:customer)
          params[:http_username] = 'abc'
          params[:http_password] = nil
          expect {
            post :create, {:customer => params}
          }.to change(Customer, :count).by(0)
          assigns(:customer).should be_a(Customer)
          assigns(:customer).should_not be_persisted
        end
  
        it "re-renders the 'new' template when show_errors is true" do
          params = Factory.attributes_for(:customer)
          params[:http_username] = 'abc'
          params[:http_password] = nil
          post :create, {:customer => params}
          response.should render_template("new")
        end
      end
    end
    
    describe "PUT approve" do
      it "(edit) unapproved record can be approved and old approved record will be updated" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
        icol_customer1 = Factory(:customer, :approval_status => 'A')
        icol_customer2 = Factory(:customer, :approval_status => 'U', :notify_url => "http://localhost", :approved_version => icol_customer1.lock_version, :approved_id => icol_customer1.id, :created_by => 666)
        # the following line is required for reload to get triggered (TODO)
        icol_customer1.approval_status.should == 'A'
        UnapprovedRecord.count.should == 1
        put :approve, {:id => icol_customer2.id}
        UnapprovedRecord.count.should == 0
        icol_customer1.reload
        icol_customer1.notify_url.should == 'http://localhost'
        icol_customer1.updated_by.should == "666"
        UnapprovedRecord.find_by_id(icol_customer2.id).should be_nil
      end
    end
    
    describe "GET audit_logs" do
      it "assigns the requested customer as @customer" do
        customer = Factory(:customer)
        get :audit_logs, {:id => customer.id, :version_id => 0}
        assigns(:record).should eq(customer)
        assigns(:audit).should eq(customer.audits.first)
        get :audit_logs, {:id => 12345, :version_id => "i"}
        assigns(:record).should eq(nil)
        assigns(:audit).should eq(nil)
      end
    end
  end

end
