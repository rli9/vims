class Picture < ActiveRecord::Base
  has_many :members

  validates_presence_of :content_type
  validates_format_of :content_type, :with => /\Aimage/, :message => 'only support pictures'
  validates_presence_of :data

  attr_accessor :picture

  def picture=(picture_field)
    if picture_field && !picture_field.kind_of?(String)
      self.content_type = picture_field.content_type
      self.data = picture_field.read
    end
  end

end
