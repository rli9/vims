class BitsInterpretersController < ApplicationController
  layout "tool"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  def list
    @bits_interpreters = BitsInterpreter.all
  end

  def show
    @bits_interpreter = BitsInterpreter.find(params[:id])
    @bits_segments = @bits_interpreter.bits_segments
  end

  def help

  end

  def interpret
    @bits_interpreter = BitsInterpreter.find(params[:id])
    @bits = '0' * @bits_interpreter.length

    @interpretion = eval '"' + @bits_interpreter.description + '"'

  end

  # FIMXE consider size == 0
  def fit_size(bits, size)
    while bits.size < size
      bits = '0' + bits
    end
    if bits.size > size
      bits = bits[bits.size - size..bits.size - 1]
    end
    bits
  end

  def bits_of(bs_name)
    bs = @bits_interpreter.bits_segments.detect {|bs| bs.name == bs_name }
    @bits[-bs.start_bit - 1..-bs.end_bit - 1]
  end

  def to_16(bits)
    fit_size(bits.to_i(2).to_s(16), (bits.size + 3) / 4)
  end

  def segments_to_bits
    @bits_interpreter = BitsInterpreter.find(params[:id])
    @bits = '0' * @bits_interpreter.length

    #FIXME check whether the range of segment is larger than @bits_interpreter.length
    @bits_interpreter.bits_segments.reverse_each do |bs|
      bits = params[:bits_segment]["#{bs.id}"]
      unless bits.nil?
        bits.gsub!(/\s/, '')
        bits = fit_size(bits, bs.start_bit - bs.end_bit + 1)

        @bits[-bs.start_bit - 1..-bs.end_bit - 1] = bits
      end
    end

    @interpretion = eval '"' + @bits_interpreter.description + '"'

    render :action => 'interpret'
  end

  def bits_to_segments
    @radix = params[:radix]
    unless params[:bits].nil?
      params[:bits].gsub!(/\s/, '')
    end
    @bits = params[:bits].to_i(@radix.to_i).to_s(2)
    @bits_interpreter = BitsInterpreter.find(params[:id])
    @bits = fit_size(@bits, @bits_interpreter.length)

    @interpretion = eval '"' + @bits_interpreter.description + '"'

    render :action => 'interpret'
  end

  #include OneToMultipleRelation

  # FIXME automatically add verify post for the methods
  #OneToMultipleRelation.create_methods_by_chain [ {:table => BitsInterpreter, :record => 'bits_interpreter',
  #                                                  :options => {"description" => {:multiple_lines => true } } },
  #{:table => BitsSegment, :record => 'bits_segment' },
  #{:table => BitsValue, :record => 'bits_value' } ]

end
