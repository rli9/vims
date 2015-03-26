class TestCaseTemplateParamInstance < ActiveRecord::Base
  belongs_to :test_case_template_param

  validates :name, presence: true, length: {maximum: 255}, format: {with: /\A[\.\=\w]+\Z/}
  validates_uniqueness_of :name, :scope => :test_case_template_param_id, :case_sensitive => false

  validates_presence_of :test_case_template_param_id
  validates_numericality_of :test_case_template_param_id, :only_integer => true

  def test_case_template
    self.test_case_template_param.test_case_template
  end

  def self.create_all(test_case_template_param, test_case_template_param_instance_names)
    #FIXME add transaction
    test_case_template_param_instances = test_case_template_param_instance_names.map do |test_case_template_param_instance_name|
      self.create(:name => test_case_template_param_instance_name, :test_case_template_param => test_case_template_param)
    end

    test_case_template = test_case_template_param.test_case_template
    test_case_template_params = test_case_template.test_case_template_params

    if test_case_template_params.size == 1 || test_case_template_param_instances.size != test_case_template_param.test_case_template_param_instances.size
      test_cases = create_test_cases(test_case_template, test_case_template_params.map {|param| param == test_case_template_param ? test_case_template_param_instances : param.test_case_template_param_instances},
                                     test_case_template.test_target_id)
    else
      raise ActiveRecord::Rollback unless test_case_template_params.last == test_case_template_param

      test_cases = extend_test_cases(test_case_template, test_case_template_param_instances.delete_at(0))

      test_cases.concat(create_test_cases(test_case_template, test_case_template_params.collect {|param| param == test_case_template_param ? test_case_template_param_instances : param.test_case_template_param_instances},
                                          test_case_template.test_target_id))
    end

    test_cases
  end

  def raw_test_case_names
    raw_test_case_names = self.test_case_template
                              .test_case_template_params
                              .collect {|param| param == self.test_case_template_param ? [self.name] : param.test_case_template_param_instances.collect(&:name)}
    [self.test_case_template.test_case_name_prefix].product(*raw_test_case_names)
  end

  def test_case_names
    self.raw_test_case_names.map {|raw_test_case_name| raw_test_case_name.join("_")}
  end

  def test_cases
    TestCase.where("test_target_id = ? and name in (?)", self.test_case_template.test_target_id, self.test_case_names)
  end

protected
  def self.create_test_cases(test_case_template, test_case_template_param_instances_array, test_target_id)
    if test_case_template_param_instances_array.size == 1
      test_case_template_param_instance_combinations = test_case_template_param_instances_array.first.product
    else
      test_case_template_param_instance_combinations = test_case_template_param_instances_array.delete_at(0).product(*test_case_template_param_instances_array)
    end

    test_case_name_prefix = test_case_template.test_case_name_prefix

    test_cases = test_case_template_param_instance_combinations.collect_every(5000) do |partial_test_case_template_param_instance_combinations|
      test_cases_hash = {}
      partial_test_case_template_param_instance_combinations.each do |combination|
        test_cases_hash[test_case_name_prefix + '_' + combination.collect(&:name).join("_")] = combination.collect(&:id)
      end

      TestCase.create(test_cases_hash.keys.map {|test_case_name| {name: test_case_name, test_target_id: test_target_id}})
    end

    test_cases.flatten
  end

  def self.extend_test_cases(test_case_template, test_case_template_param_instance)
    raw_test_case_names = test_case_template.test_case_template_params[0..-2].map {|test_case_template_param| test_case_template_param.test_case_template_param_instances.map(&:name)}
    test_case_names = [test_case_template.test_case_name_prefix].product(*raw_test_case_names).map {|raw_test_case_name| raw_test_case_name.join('_')}

    test_cases = TestCase.where("test_target_id = ? and name in (?)", test_case_template.test_target_id, test_case_names)

    test_cases.every(5000) do |partial_test_cases|
      test_case_ids = partial_test_cases.collect(&:id)
      TestCase.update_test_case_names('name', test_case_template_param_instance.name, test_case_ids)
    end

    test_cases
  end

end
