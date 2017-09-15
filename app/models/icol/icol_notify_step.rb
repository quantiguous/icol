class IcolNotifyStep < ActiveRecord::Base
  lazy_load :req_header, :rep_header, :req_bitstream, :rep_bitstream, :fault_bitstream
  belongs_to :icol_notification
end