class IcolCustomerSearcher
  include ActiveModel::Validations
  attr_accessor :page, :approval_status, :app_code, :customer_code
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
      IcolCustomer.none.paginate(per_page: PER_PAGE, page: page)
    end
  end

  private  
  def persisted?
    false
  end

  def find
    reln = approval_status == 'U' ? IcolCustomer.unscoped.where("approval_status =?",'U').order("id desc") : IcolCustomer.order("id desc")
    reln = reln.where("app_code=?", app_code) if app_code.present?
    reln = reln.where("customer_code=?", customer_code) if customer_code.present?
    reln
  end
end