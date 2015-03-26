class BitsSegment < ActiveRecord::Base
  validates_presence_of :name, :start_bit, :end_bit, :bits_interpreter_id
  
  validates_numericality_of :start_bit, :only_integer => true
  validates_numericality_of :end_bit, :only_integer => true
  validates_numericality_of :bits_interpreter_id, :only_integer => true
  
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 255, :allow_nil => true
  validates_length_of :start_bit, :maximum => 11
  validates_length_of :end_bit, :maximum => 11
  validates_length_of :bits_interpreter_id, :maximum => 11

  belongs_to :bits_interpreter
  has_many :bits_values
  
  def validate_position(position)
    unless send(position).nil?
      if send(position) > bits_interpreter.length - 1 || send(position) < 0
        errors.add(position, "should in the range [0..#{bits_interpreter.length - 1}]")
      end
      bits_segment = bits_interpreter.bits_segments.detect {|bits_segment| id != bits_segment.id && send(position) <= bits_segment.start_bit && send(position) >= bits_segment.end_bit }
      unless bits_segment.nil?
        errors.add(position, "should not within the range of others, e.g. ['#{bits_segment.name}', '#{bits_segment.start_bit}..#{bits_segment.end_bit}']")
      end
    end    
  end
  
  def validate   
    if bits_interpreter.nil?
      errors.add(:bits_interpreter_id, "should not be nil")
    else
      validate_position :start_bit
      validate_position :end_bit

      if start_bit && end_bit && start_bit < end_bit
        errors.add(:start_bit, "should larger than or equal to end_bit")
      end

      name.strip!
      if bits_interpreter.bits_segments.detect {|bits_segment| id != bits_segment.id && bits_segment.name == name }
        errors.add(:name, "'#{name}' is duplicated")
      end
    end
  end  
end
