class ValidateStepSearcher
  include ActiveModel::Validations
  attr_accessor :page, :app_code, :customer_code, :step_name, :status_code, :from_request_timestamp, :to_request_timestamp, :from_reply_timestamp, :to_reply_timestamp
  PER_PAGE = 10
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def paginate
    if valid? 
      find.paginate(per_page: PER_PAGE, page: page)
    else
      ValidateStep.none.paginate(per_page: PER_PAGE, page: page)
    end
  end

  private  
  def persisted?
    false
  end

  def find
    reln = ValidateStep.order("id desc")
    reln = reln.where("app_code=?", app_code) if app_code.present?
    reln = reln.where("customer_code=?", customer_code) if customer_code.present?
    reln = reln.where("step_name=?", step_name) if step_name.present?
    reln = reln.where("status_code=?", status_code) if status_code.present?
    reln = reln.where("req_timestamp>=? and req_timestamp<=?",Time.zone.parse(from_request_timestamp).beginning_of_day,Time.zone.parse(to_request_timestamp).end_of_day) if from_request_timestamp.present? && to_request_timestamp.present?
    reln = reln.where("rep_timestamp>=? and rep_timestamp<=?",Time.zone.parse(from_reply_timestamp).beginning_of_day,Time.zone.parse(to_reply_timestamp).end_of_day) if from_reply_timestamp.present? && to_reply_timestamp.present?
    reln
  end
end
