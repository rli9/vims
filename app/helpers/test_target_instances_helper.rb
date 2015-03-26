module TestTargetInstancesHelper
  TEST_RESULT_TD = {TestResult::TEST_TARGET_PASS => "<td bgcolor='#00ff00' align='center' nowrap>P</td>",
                    TestResult::TEST_TARGET_NEW_FAIL => "<td bgcolor='red' align='center' nowrap>NF</td>",
                    TestResult::TEST_CASE_FAIL => "<td bgcolor='yellow' align='center' nowrap>CF</td>"}

  def test_result_td(test_result)
    html = if test_result.nil?
      "<td bgcolor='gray' align='center'> </td>"
    else
      TEST_RESULT_TD[test_result.value]
    end
    raw(html)
  end

  def test_case_performance_chart(test_results_hash)
    sorted_test_target_instances = test_results_hash.values.collect {|item| item[0]}.sort {|x, y| y.change_list_id <=> x.change_list_id }
    test_time_collection = sorted_test_target_instances.collect {|instance| test_results_hash[instance.id][1].collect(&:result).compact}

    sorted_test_time_collection = test_time_collection.flatten.uniq.sort {|x, y| x <=> y}

    unless sorted_test_time_collection.empty?
      min = sorted_test_time_collection.first.to_i
      max = sorted_test_time_collection.last.ceil

      x_max = (max / 10 + 1) * 10

      chxl = "0:|#{sorted_test_target_instances.collect(&:name).join("|")}|end|1:|0|#{x_max / 2}|#{x_max}"

      x_data = []
      test_time_collection.each_index {|index| x_data << test_time_collection[index].collect {|item| index} }

      chd = "t:#{x_data.flatten.join(',')}|#{test_time_collection.flatten.join(',')}"

      chart_s(:chs => "900x300",
              :chxt => "x,y",
              :chxl => chxl,
              :chd => chd,
              :chds => "0,#{sorted_test_target_instances.size},0,#{x_max}",
              :chm => "x,00ff00,0,1.0,8.0",
              :chg => "#{100.0 / sorted_test_target_instances.size},10,2,3",
              :chtt => "Performance Chart")
    end
  end

end
