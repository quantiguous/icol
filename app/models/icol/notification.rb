module Icol
  class Notification < ActiveRecord::Base
    has_many :notify_steps
  end
end
