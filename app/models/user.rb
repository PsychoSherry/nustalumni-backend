class User
  include Mongoid::Document
  require 'digest/md5'

  field :name,                :type => String,  :default => ""
  field :name_first,          :type => String,  :default => ""
  field :name_last,           :type => String,  :default => ""

  field :image,               :type => String,  :default => ""
  field :email,               :type => String,  :default => ""
  field :encrypted_password,  :type => String,  :default => ""

  field :course,              :type => String,  :default => ""
  field :campus,              :type => String,  :default => ""
  field :discipline,          :type => String,  :default => ""
  field :job_position,        :type => String,  :default => ""
  field :job_company,         :type => String,  :default => ""

  field :volunteer,           :type => Boolean, :default => false
  field :graduate,            :type => Boolean, :default => false
  field :course_year,         :type => Integer, :default => 0
  field :professional_status, :type => Integer, :default => 0

  # 0 => looking for new employment opportunities
  # 1 => seeking to employ fresh graduates
  # 2 => looking to connect with decision makers       

  validates :name,     :presence => true
  validates :email,    :presence => true, :uniqueness => true

  before_save :calculate_data

  def calculate_data
    # Strip name of multiple spaces
    if not self.name_first.blank?
      self.name = (self.name_first + ' ' + self.name_last).gsub(/\s+/, ' ')
    end 

    # Calculate Image Gravatar
    self.email = self.email.downcase.delete(' ')

    hash = Digest::MD5.hexdigest(self.email)
    self.image = "http://www.gravatar.com/avatar/#{hash}?d=mm&r=pg&s=80"
  end



##### leave the shit below as is, they are devise modules #############
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Token authenticatable
  field :authentication_token, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
end
