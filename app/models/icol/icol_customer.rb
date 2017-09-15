class IcolCustomer < ActiveRecord::Base
  include Approval2::ModelAdditions
  
  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by'
  belongs_to :updated_user, class_name: 'User', foreign_key: 'updated_by'
  
  SETTING_TYPES = ['text','number','date']
  validate :atleast_one_url_should_present?
  
  validates_presence_of :customer_code, :app_code, :is_enabled
  validates_numericality_of :retry_notify_in_mins, :max_retries_for_notify, allow_blank: true
  validates_uniqueness_of :customer_code, scope: [:approval_status]
  validates_length_of :http_username, maximum: 100, allow_blank: true
  validates_length_of :http_password, maximum: 100, allow_blank: true
  
  validates :customer_code, format: {with: /\A[a-z|A-Z|0-9|\.|\-]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\.|\-]}' }, length: { maximum: 15 }
  validates :app_code, format: {with: /\A[a-z|A-Z|0-9|\.|\-]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\.|\-]}' }, length: { maximum: 50 }
  validates :notify_url, :validate_url, format: {with: URI.regexp, :message => 'Invalid format, expected format is : https://example.com' }, length: { maximum: 100 }, allow_blank: true
    
  store :setting1, accessors: [:setting1_name, :setting1_type, :setting1_value], coder: JSON
  store :setting2, accessors: [:setting2_name, :setting2_type, :setting2_value], coder: JSON
  store :setting3, accessors: [:setting3_name, :setting3_type, :setting3_value], coder: JSON
  store :setting4, accessors: [:setting4_name, :setting4_type, :setting4_value], coder: JSON
  store :setting5, accessors: [:setting5_name, :setting5_type, :setting5_value], coder: JSON
  
  validate :settings_should_be_correct
  validate :password_should_be_present
  
  validates_presence_of :setting1_name, if: "setting1_name.blank? && !setting2_name.blank?", message: "can't be blank when Setting2 name is present"
  validates_presence_of :setting2_name, if: "setting2_name.blank? && !setting3_name.blank?", message: "can't be blank when Setting3 name is present"
  validates_presence_of :setting3_name, if: "setting3_name.blank? && !setting4_name.blank?", message: "can't be blank when Setting4 name is present"
  validates_presence_of :setting4_name, if: "setting4_name.blank? && !setting5_name.blank?", message: "can't be blank when Setting5 name is present"

  before_save :set_settings_cnt
  before_save :encrypt_password
  after_save :decrypt_password
  after_find :decrypt_password

  private

  def atleast_one_url_should_present?
    if notify_url.blank? & validate_url.blank?
      errors.add :base, "Require atleast one of them notify url, validate url"
    end
  end
  
  def set_settings_cnt
    self.settings_cnt = 0
    self.settings_cnt += 1 unless setting1_name.blank?
    self.settings_cnt += 1 unless setting2_name.blank?
    self.settings_cnt += 1 unless setting3_name.blank?
    self.settings_cnt += 1 unless setting4_name.blank?
    self.settings_cnt += 1 unless setting5_name.blank?
  end

  def settings_should_be_correct
    validate_setting(:setting1_value, setting1_name, setting1_type, setting1_value)
    validate_setting(:setting2_value, setting2_name, setting2_type, setting2_value)
    validate_setting(:setting3_value, setting3_name, setting3_type, setting3_value)
    validate_setting(:setting4_value, setting4_name, setting4_type, setting4_value)
    validate_setting(:setting5_value, setting5_name, setting5_type, setting5_value)
  end

  def validate_setting(attr_name, setting_name, setting_type, setting_value)
    errors.add(attr_name, "can't be blank") if setting_name.present? && setting_value.blank?
    if setting_name.present? and setting_value.present?
      errors.add(attr_name, "invalid format, the correct format is yyyy-mm-dd") if (setting_type == "date" && setting_value =~ /\A\d{4}\-\d{2}\-\d{2}+$\z/).nil?
      Time.zone.parse setting_value rescue errors.add(attr_name, "is not a date") if setting_type == "date"
      errors.add(attr_name, "is longer than maximum (100)") if setting_type == "text" && setting_value.length > 100
      errors.add(attr_name, "should include only digits") if setting_type == "number" && (setting_value =~ /\A[0-9]+$\z/).nil?
    end
  end

  def decrypt_password
    self.http_password = DecPassGenerator.new(http_password,ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']).generate_decrypted_data if http_password.present?
  end
  
  def encrypt_password
    self.http_password = EncPassGenerator.new(self.http_password, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']).generate_encrypted_password unless http_password.to_s.empty?
  end
  
  def password_should_be_present
    errors[:base] << "HTTP Password can't be blank if HTTP Username is present" if self.http_username.present? and (self.http_password.blank? or self.http_password.nil?)
  end
end