class Invxp < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "invxp_#{Rails.env}"
end