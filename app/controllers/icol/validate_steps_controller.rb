module Icol
  class ValidateStepsController < ApplicationController
    authorize_resource
    before_filter :authenticate_user!
    before_filter :block_inactive_user!
    respond_to :json
    include ApplicationHelper
    
    def index
      if request.get?
        @searcher = ValidateStepSearcher.new(params.permit(:page))
      else
        @searcher = ValidateStepSearcher.new(search_params)
      end
      @records = @searcher.paginate
    end
    
    def show
      @validate_step = ValidateStep.find_by_id(params[:id])
    end
    
    private
  
    def search_params
      params.permit(:page, :app_code, :customer_code, :step_name, :status_code, :from_request_timestamp, :to_request_timestamp, :from_reply_timestamp, :to_reply_timestamp)
    end
  end
end
