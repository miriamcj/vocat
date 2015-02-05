class Token < ActiveRecord::Base

  belongs_to :user
  before_validation :generate_token
  before_validation :set_expires_at
  validates :token, presence: true

  def valid_token?
    self.expires_at > Time.now
  end

  def update_last_seen
    self.last_seen_at = DateTime.now
    self.touch
    self.save
  end

  protected

  def refresh
    self.expires_at += 30.days
  end

  def set_expires_at
    self.expires_at = Time.now
    self.refresh
  end

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end

end
