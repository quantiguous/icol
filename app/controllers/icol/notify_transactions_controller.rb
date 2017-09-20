module Icol
  class NotifyTransactionsController < ApplicationController
    authorize_resource
    before_filter :authenticate_user!
    before_filter :block_inactive_user!
    respond_to :json
    include ApplicationHelper
    
    def new
      @notify_transaction = NotifyTransaction.new
    end
  
    def create
      @notify_transaction = NotifyTransaction.new(params[:notify_transaction])
      if !@notify_transaction.valid?
        render "new"
      else
        @notify_transaction.save!
        flash[:alert] = 'Notify Transaction successfully created'
        redirect_to notify_transactions_path
      end
    end
  
    def edit
      @notify_transaction = NotifyTransaction.find(params[:id])
    end
  
    def update
      @notify_transaction = NotifyTransaction.find(params[:id])
      @notify_transaction.attributes = notify_transaction_params
      if !@notify_transaction.valid?
        render "edit"
      else
        @notify_transaction.save!
        flash[:alert] = 'Notify Transaction successfully modified'
        redirect_to notify_transactions_path
      end
    end
  
    def index
      icol_notify_transactions = NotifyTransaction.order("crtd_date_time desc")
      @icol_notify_transactions_count = icol_notify_transactions.count
      @icol_notify_transactions = icol_notify_transactions.paginate(:per_page => 10, :page => params[:page]) rescue []
    end
  
    def show
      @notify_transaction = NotifyTransaction.find(params[:id])
    end
  
    def destroy
      notify_transaction = NotifyTransaction.find(params[:id])
      if notify_transaction.destroy
        flash[:alert] = "Notify Transaction record has been deleted!"
      else
        flash[:alert] = "Notify Transaction record cannot be deleted!"
      end
      redirect_to notify_transactions_path
    end
  
    private
      def notify_transaction_params
        params.require(:notify_transaction).permit(:template_id, :compny_id, :comapny_name, :trnsctn_mode, :trnsctn_nmbr, :payment_status,:template_data)
      end
  end
end
