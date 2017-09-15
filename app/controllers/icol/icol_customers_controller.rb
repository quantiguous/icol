class IcolCustomersController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper

  def new
    @icol_customer = IcolCustomer.new
  end

  def create
    @icol_customer = IcolCustomer.new(icol_customer_params)
    if !@icol_customer.valid?
      render "new"
    else
      @icol_customer.created_by = current_user.id
      @icol_customer.save!
      flash[:alert] = 'IcolCustomer successfully created and is pending for approval'
      redirect_to @icol_customer
    end
  end

  def update
    @icol_customer = IcolCustomer.unscoped.find_by_id(params[:id])
    @icol_customer.attributes = params[:icol_customer]
    if !@icol_customer.valid?
      render "edit"
    else
      @icol_customer.updated_by = current_user.id
      @icol_customer.save!
      flash[:alert] = 'IcolCustomer successfully modified successfully'
      redirect_to @icol_customer
    end
    rescue ActiveRecord::StaleObjectError
      @icol_customer.reload
      flash[:alert] = 'Someone edited the customer the same time you did. Please re-apply your changes to the customer.'
      render "edit"
  end 

  def show
    @icol_customer = IcolCustomer.unscoped.find_by_id(params[:id])
  end

  def index
    if request.get?
      @searcher = IcolCustomerSearcher.new(params.permit(:page, :approval_status))
    else
      @searcher = IcolCustomerSearcher.new(search_params)
    end
    @records = @searcher.paginate
  end

  def audit_logs
    @record = IcolCustomer.unscoped.find(params[:id]) rescue nil
    @audit = @record.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'icol')
  end

  private

  def icol_customer_params
    params.require(:icol_customer).permit(:customer_code, :app_code, :settings_cnt, 
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