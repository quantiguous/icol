module Icol
  class NotifyTransaction < Invxp
    self.primary_key = :trnsctn_nmbr
    self.table_name = "trnsctn_stt"
    before_validation :set_created_at
    
    validates_presence_of :template_id, :compny_id, :comapny_name, :trnsctn_mode, :trnsctn_nmbr, :payment_status, :template_data
    validates_uniqueness_of :trnsctn_nmbr
    validates :payment_status, length: { maximum: 3 }
    validates :trnsctn_mode, length: { maximum: 3 }
    validates :template_data, length: { maximum: 1000 }
    validates :comapny_name, length: { maximum: 100 }
    validates_numericality_of :template_id, :compny_id, :trnsctn_nmbr
    
    def set_created_at
      self.crtd_date_time = Time.now
    end
  end
end
