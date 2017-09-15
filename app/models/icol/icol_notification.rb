class Notification < ActiveRecord::Base
  has_many :icol_notify_steps
end
