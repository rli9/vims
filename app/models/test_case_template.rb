class TestCaseTemplate < ActiveRecord::Base
  belongs_to :test_target
  has_many :test_case_template_params, -> {order :seq}, :dependent => :destroy

  validates :name, presence: true, length: {maximum: 255}, format: {with: /\A[A-Za-z0-9]+\Z/}

  validates_length_of :name, :maximum => 255
  validates_uniqueness_of :name, :scope => :test_target_id

  validates_presence_of :test_target_id
  validates_numericality_of :test_target_id, :only_integer => true

  def test_case_name_prefix
    self.name.scan(/\w+/).join("_")
  end

  def test_cases
    TestCase.where('test_target_id = ? and name in (?)', self.test_target_id, self.test_case_names)
  end

  def raw_test_case_names
    test_case_template_params = self.test_case_template_params.includes(:test_case_template_param_instances)

    raw_test_case_names = test_case_template_params.map {|test_case_template_param| test_case_template_param.test_case_template_param_instances.map(&:name)}
    [self.test_case_name_prefix].product(*raw_test_case_names)
  end

  def test_case_names
    self.raw_test_case_names.map {|raw_test_case_name| raw_test_case_name.join('_')}
  end

  def test_case_names_matrix(test_case_template_param_matcheses)
    test_case_name_prefix = self.test_case_name_prefix + '_'

    test_case_template_param_matcheses.first.map do |test_case_template_param_match|
      [test_case_template_param_match].product(*test_case_template_param_matcheses[1..-1]).map {|test_case_name| test_case_name_prefix + test_case_name.join('_')}
    end
  end

  def deletable?
    self.test_case_template_params.empty?
  end

  def regexp
    capturings = self.test_case_template_params.map {|param| Struct.new(:key, :capture).new("key#{param.id}".to_s, param.name)}

    Struct.new(:keys, :expression).new(capturings.map(&:key), /^(?i:(#{self.test_case_name_prefix}_#{capturings.map {|capturing| "(?<#{capturing.key}>#{capturing.capture})"}.join('_')}))$/)
  end
end
