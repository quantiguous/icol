module Icol
  class NotifyTransactionsController < ApplicationController
    authorize_resource
    before_filter :authenticate_user!
    before_filter :block_inactive_user!
    respond_to :json
    include ApplicationHelper
    
    def new
      @icol_notify_transaction = NotifyTransaction.new
    end
  
    def create
      @icol_notify_transaction = NotifyTransaction.new(params[:icol_notify_transaction])
      if !@icol_notify_transaction.valid?
        render "new"
      else
        @icol_notify_transaction.save!
        flash[:alert] = 'Notify Transaction successfully created'
        redirect_to icol_notify_transactions_path
      end
    end
  
    def edit
      @icol_notify_transaction = NotifyTransaction.find(params[:id])
    end
  
    def update
      @icol_notify_transaction = NotifyTransaction.find(params[:id])
      @icol_notify_transaction.attributes = notify_transaction_params
      if !@icol_notify_transaction.valid?
        render "edit"
      else
        @icol_notify_transaction.save!
        flash[:alert] = 'Notify Transaction successfully modified'
        redirect_to icol_notify_transactions_path
      end
    end
  
    def index
      icol_notify_transactions = NotifyTransaction.order("crtd_date_time desc")
      @icol_notify_transactions_count = icol_notify_transactions.count
      @icol_notify_transactions = icol_notify_transactions.paginate(:per_page => 10, :page => params[:page]) rescue []
    end
  
    def show
      @icol_notify_transaction = NotifyTransaction.find(params[:id])
    end
  
    def destroy
      icol_notify_transaction = NotifyTransaction.find(params[:id])
      if icol_notify_transaction.destroy
        flash[:alert] = "Notify Transaction record has been deleted!"
      else
        flash[:alert] = "Notify Transaction record cannot be deleted!"
      end
      redirect_to icol_notify_transactions_path
    end
  
    private
      def icol_notify_transaction_params
        params.require(:icol_notify_transaction).permit(:template_id, :compny_id, :comapny_name, :trnsctn_mode, :trnsctn_nmbr, :payment_status,:template_data)
      end
  end
end
