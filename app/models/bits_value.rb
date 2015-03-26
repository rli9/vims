class BitsValue < ActiveRecord::Base
  validates_presence_of :bits_segment_id, :bits, :description
  validates_length_of :description, :within => 1..255
  validates_length_of :bits_segment_id, :maximum => 11
  validates_numericality_of :bits_segment_id, :only_integer => true
  
  belongs_to :bits_segment
  
  def validate
    bits.gsub!(/\s/, '')
    
    errors.add(:bits, "should only consist 0 and 1") if bits =~ /[^01]/
    if bits_segment.nil?
      errors.add(:bits_segment_id, "should not be nil")
    else
      expect_size = bits_segment.start_bit - bits_segment.end_bit + 1
      if bits.size != expect_size
        errors.add(:bits, "should be #{expect_size} characters")
      end      
      if bits_segment.bits_values.detect {|bits_value| id != bits_value.id && bits_value.bits == bits }
        errors.add(:bits, "'#{bits}' is duplicated")
      end
    end
  end
end