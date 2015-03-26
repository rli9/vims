class BitsInterpreter < ActiveRecord::Base
  validates_presence_of :name, :length

  validates_numericality_of :length, :only_integer => true
  validates_inclusion_of :length, :in => [16, 32, 48, 64, 1024], :message => "valid value [16, 32, 48, 64, 1024]"
  validates_length_of :name, :maximum => 255
  validates_uniqueness_of :name

  validates_length_of :description, :maximum => 255, :allow_nil => true

  has_many :bits_segments, -> {order :start_bit}

  def validate
    name.strip!
  end
end
