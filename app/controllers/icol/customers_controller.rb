module Icol
  class CustomersController < ApplicationController
    authorize_resource
    before_filter :authenticate_user!
    before_filter :block_inactive_user!
    respond_to :json
    include Approval2::ControllerAdditions
    include ApplicationHelper
  
    def new
      @customer = Customer.new
    end
  
    def create
      @customer = Customer.new(customer_params)
      if !@customer.valid?
        render "new"
      else
        @customer.created_by = current_user.id
        @customer.save!
        flash[:alert] = 'Customer successfully created and is pending for approval'
        redirect_to @customer
      end
    end
  
    def update
      @customer = Customer.unscoped.find_by_id(params[:id])
      @customer.attributes = customer_params
      if !@customer.valid?
        render "edit"
      else
        @customer.updated_by = current_user.id
        @customer.save!
        flash[:alert] = 'Customer successfully modified successfully'
        redirect_to @customer
      end
      rescue ActiveRecord::StaleObjectError
        @customer.reload
        flash[:alert] = 'Someone edited the customer the same time you did. Please re-apply your changes to the customer.'
        render "edit"
    end 
  
    def show
      @customer = Customer.unscoped.find_by_id(params[:id])
    end
  
    def index
      if request.get?
        @searcher = CustomerSearcher.new(params.permit(:page, :approval_status))
      else
        @searcher = CustomerSearcher.new(search_params)
      end
      @records = @searcher.paginate
    end
  
    def audit_logs
      @record = Customer.unscoped.find(params[:id]) rescue nil
      @audit = @record.audits[params[:version_id].to_i] rescue nil
    end
  
    def approve
      redirect_to main_app.unapproved_records_path(group_name: 'icol')
    end
  
    private
  
    def customer_params
      params.require(:customer).permit(:customer_code, :app_code, :settings_cnt, 
      :lock_version, :last_action, :updated_by, :notify_url, :validate_url, 
      :http_username, :http_password, :approval_status, :approved_version, 
      :approved_id, :max_retries_for_notify, :retry_notify_in_mins,
      :setting1_name, :setting1_type, :setting1_value, 
      :setting2_name, :setting2_type, :setting2_value, 
      :setting3_name, :setting3_type, :setting3_value, 
      :setting4_name, :setting4_type, :setting4_value,
      :setting5_name, :setting5_type, :setting5_value
      )
    end
    
    def search_params
      params.permit(:page, :approval_status, :app_code, :customer_code)
    end
    
  end
end
