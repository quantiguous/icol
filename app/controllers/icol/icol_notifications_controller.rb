class IcolNotificationsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  
  def index
    if request.get?
      @searcher = IcolNotificationSearcher.new(params.permit(:page))
    else
      @searcher = IcolNotificationSearcher.new(search_params)
    end
    @records = @searcher.paginate
  end
  
  def show
    @icol_notification = IcolNotification.find(params[:id])
  end
  
  def audit_steps
    icol_notification = IcolNotification.find(params[:id])
    steps = icol_notification.icol_notify_steps
    @steps = steps.order("id desc").paginate(page: params[:page], per_page: 10)
  end
  
  private
  
  def search_params
    params.permit(:page, :app_code, :customer_code, :txn_number, :status_code, :payment_status)
  end

end