class IcolNotificationSearcher
  include ActiveModel::Validations
  attr_accessor :page, :app_code, :customer_code, :txn_number, :status_code, :payment_status
  PER_PAGE = 10

  validates :txn_number, format: {with: /\A[\d]+\z/}, unless: "txn_number.blank?"
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def paginate
    if valid?
      find.paginate(per_page: PER_PAGE, page: page)
    else
      IcolNotification.none.paginate(per_page: PER_PAGE, page: page)
    end
  end

  private

  def persisted?
    false
  end

  def find
    reln = IcolNotification.order("id desc")
    reln = reln.where("app_code=?", app_code) if app_code.present?
    reln = reln.where("customer_code=?", customer_code) if customer_code.present?
    reln = reln.where("txn_number=?", txn_number) if txn_number.present?
    reln = reln.where("status_code=?", status_code) if status_code.present?
    reln = reln.where("payment_status=?", payment_status) if payment_status.present?
    reln
  end
end