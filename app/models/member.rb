class Member < ActiveRecord::Base
  has_and_belongs_to_many :projects, -> {order 'name'}

  belongs_to :picture

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :within => 1..255

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_length_of :email, :within => 11..255
  validates_format_of :email, :with => /@.*\.com/, :message => 'need have a valid email account'

  validates_presence_of :password, :if => :password_required?
  validates_length_of :password, :within => 6..255, :if => :password_required?

  validates_numericality_of :picture_id, :only_integer => true
  validates_length_of :picture_id, :maximum => 11, :allow_nil => true

  attr_accessor :password

  before_create :hashize_password
  before_update :require_password
  after_save :clear_password

  def hashize_password
    self.hashed_password = Digest::SHA1.hexdigest(self.password)
  end

  def require_password
    if password_required?
      self.hashed_password = Digest::SHA1.hexdigest(self.password)
    end
  end

  def clear_password
    self.password = nil
    self.hashed_password = nil
  end

  def validate_password?(password)
    self.hashed_password == Digest::SHA1.hexdigest(password)
  end

  def self.authenticate?(member)
    find_by_name_and_hashed_password(member.name, Digest::SHA1.hexdigest(member.password))
  end

  def deletable?
    self.projects.empty?
  end

  def password_required?
    hashed_password.nil? || hashed_password.blank?
  end

  def test_cases_count_of(test_target_instance)
    TestResult.count('id', :conditions => ["test_target_instance_id = ? and created_by = ?", test_target_instance, self])
  end
end
