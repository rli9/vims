class TestReport
  def self.types
    [:fix, :regression, :block, :new_pass, :new_fail, :new_block, :keep_fail]
  end

  def self.color_classes
    ["green", "red", "yellow", "green", "red", "yellow", "red"]
  end

  def self.report(test_datas, test_datas_before, field)
    report = {:old_pass => [], :old_fail => [], :old_block => [], :unexectued => [],
              :regression => [], :keep_fail => [], :new_fail => [], :keep_pass => [],
              :fix => [], :new_pass => [], :block => [], :new_block => []}

    test_datas_before.each do |test_data_before|
      test_data = test_datas.detect do |test_data|
        test_data.send(field).id == test_data_before.send(field).id
      end

      test_report_item = TestReportItem.new(test_data, test_data_before)

      # => pass        fail          block     unexectued
      # pass        keep pass   regression    block     old pass
      # fail        fix         keep fail     block     old fail
      # block       new pass    new fail      new block old block
      # unexectued  new pass    new fail      new block unexectued

      if test_data.nil? || test_data.test_target_unexecuted? || test_data.test_case_fail?
        if test_data_before.test_target_pass?
          report[:old_pass] << test_report_item
        elsif test_data_before.test_target_fail?
          report[:old_fail] << test_report_item
        else
          report[:unexectued] << test_report_item
        end
      elsif test_data.test_target_fail?
        if test_data_before.test_target_pass?
          report[:regression] << test_report_item
        elsif test_data_before.test_target_fail?
          report[:keep_fail] << test_report_item
        else
          report[:new_fail] << test_report_item
        end
      elsif test_data.test_target_pass?
        if test_data_before.test_target_pass?
          report[:keep_pass] << test_report_item
        elsif test_data_before.test_target_fail?
          report[:fix] << test_report_item
        else
          report[:new_pass] << test_report_item
        end
      end
    end

    report
  end
end

class TestReportItem
  attr_accessor :right, :left

  def initialize(right, left)
    self.right = right
    self.left = left
  end
end