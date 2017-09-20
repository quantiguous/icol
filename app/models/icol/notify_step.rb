module Icol
  class NotifyStep < ActiveRecord::Base
    lazy_load :req_header, :rep_header, :req_bitstream, :rep_bitstream, :fault_bitstream
    belongs_to :notification, foreign_key: :icol_notification_id
  end
end
