module GoogleChartHelper
  def chart_s(ch)
    params = ch.keys.collect do |key|
      "#{key}=#{ch[key]}"
    end
    puts "http://chart.apis.google.com/chart?cht=s&amp;#{params.join("&amp;")}"
    "<img src=\"http://chart.apis.google.com/chart?cht=s&amp;#{params.join("&amp;")}\" alt=\"#{ch[:chtt]}\" />"
  end

  def chart_lc(ch)
    params = ch.keys.collect do |key|
      "#{key}=#{ch[key]}"
    end
    raw("<img src=\"http://chart.apis.google.com/chart?cht=lc&amp;#{params.join("&amp;")}\" alt=\"#{ch[:chtt]}\" />")
  end

  def chart_bvs(ch)
    params = ch.keys.collect do |key|
      "#{key}=#{ch[key]}"
    end

    "<img src=\"http://chart.apis.google.com/chart?cht=bvs&amp;chbh=a&amp;#{params.join("&amp;")}\" alt=\"#{ch[:chtt]}\" />"
  end

  def chart_bhs(ch)
    params = ch.keys.collect do |key|
      "#{key}=#{ch[key]}"
    end

    "<img src=\"http://chart.apis.google.com/chart?cht=bhs&amp;chbh=a&amp;#{params.join("&amp;")}\" alt=\"#{ch[:chtt]}\" />"
  end

  def chart_lhs(ch)
    params = ch.keys.collect do |key|
      "#{key}=#{ch[key]}"
    end

    "<img src=\"http://chart.apis.google.com/chart?#{params.join("&amp;")}\" alt=\"#{ch[:chtt]}\" />"
  end

  def chart_bhg(ch)
    params = ch.keys.collect do |key|
      "#{key}=#{ch[key]}"
    end

    "<img src=\"http://chart.apis.google.com/chart?cht=bhs&amp;chbh=a&amp;#{params.join("&amp;")}\" alt=\"#{ch[:chtt]}\" />"
  end

  def chart_bvs_array(ch, items)
    max = (items.max + 99) / 100 * 100
    chart_bvs (ch.merge(:chd => 't:' + items.join(","),
                        :chds => "0, #{max}",
                        :chxt => 'x, y',
                        :chxr => "1, 0, #{max}"))
  end

  def chart_lxy_indicator_recent_ten_test_results(ch)
    chart_lc(ch)
  end

  def chart_bvs_percentage_array(ch)
    chart_bvs(ch.merge(:chds => "0, 110",
                       :chbh => "25, 40",
                       :chg => "120, 9.09, 1, 0",
                       :chxt => 'x, y, r, x'))
  end

  def chart_bhs_percentage_array(ch)
    chart_bhs(ch.merge(:chds => "0, 110",
                       :chbh => "25, 10",
                       :chg => "120, 14.46, 1, 0",
                       :chxt => 'x, y, r'))
  end

  def data_array_to_array_chm(data_arrays)
    data_arrays_chm = []
    flag_arrays = Array.new(data_arrays[0].size)
    flag_arrays.each_index do |flag_index|
      flag_arrays[flag_index] = false
    end

    data_arrays.each_index do |data_arrays_index|
      data_array = data_arrays[data_arrays_index]

      data_array_chm = []
      data_array.each_index do |data_array_index|
        if data_array[data_array_index] != 0
          flag_arrays[data_array_index] = true
          data_array_chm << "t#{data_array[data_array_index]}, 000000, #{data_arrays_index}, #{data_array_index}, 10"
        elsif data_arrays_index == data_arrays.size - 1 && flag_arrays[data_array_index] == false
          data_array_chm << "t#{data_array[data_array_index]}, 000000, #{data_arrays_index}, #{data_array_index}, 10"
        end
      end
      unless data_array_chm.empty?
          data_arrays_chm << data_array_chm
      end
    end
    data_arrays_chm
  end

  def chart_bvs_indicator_test_results(ch, data_arrays, percentage_arrays)
    data_arrays_chm = data_array_to_array_chm(data_arrays)

    chart_bvs_percentage_array(ch.merge(:chd => 't:' + percentage_arrays.collect {|percentage_array| percentage_array.join(",")}.join("|"),
                                        :chdl => 'Pass|Fail',
                                        :chco => '00FF00, FF0000',
                                        :chm => "#{data_arrays_chm.collect {|data_array_chm| data_array_chm.join("|")}.join("|")}"))
  end

  def chart_bhs_indicator_test_results(ch, data_arrays, percentage_arrays)
    data_arrays_chm = data_array_to_array_chm(data_arrays)

    chart_bhs_percentage_array(ch.merge(:chd => 't:' + percentage_arrays.collect {|percentage_array| percentage_array.join(",")}.join("|"),
                                        :chdl => 'Pass|Fail',
                                        :chco => '00FF00, FF0000',
                                        :chm => "#{data_arrays_chm.collect {|data_array_chm| data_array_chm.join("|")}.join("|")}"))
  end

  def chart_line_indicator_test_results(ch, data_arrays)
    chart_lhs(ch.merge(:chd => "t:" + data_arrays.join(",")))
  end

  PASS = 0
  FAIL = 1
  BLOCK = 2
  UNEXECUTED = 3

  def test_progress_chart_of_test_case_schedulers(test_case_schedulers, title = nil)
    test_results = test_case_schedulers.collect {|test_case_scheduler| test_case_scheduler.test_result ? test_case_scheduler.test_result : WeightedTestResult.empty_new}
    return raw(test_progress_chart(test_results, title))
  end

  def test_progress_chart(weighted_test_results, title = nil)
    percentage_arrays = [[], [], [], []]
    data_arrays = [[], [], [], []]

    pass = weighted_test_results.select {|test_result| test_result.test_target_pass?}.size
    fail = weighted_test_results.select {|test_result| test_result.test_target_fail?}.size
    unexecuted = weighted_test_results.select {|test_result| test_result.test_case_fail? || test_result.test_target_unexecuted?}.size

    data_arrays[PASS] << pass
    data_arrays[FAIL] << fail
    data_arrays[UNEXECUTED] << unexecuted

    if weighted_test_results.empty?
      percentage_arrays[PASS] << 0
      percentage_arrays[FAIL] << 0
      percentage_arrays[UNEXECUTED] << 100

      complete_percentage = 100
    else
      percentage_arrays[PASS] << percentage(pass, weighted_test_results.size)
      percentage_arrays[FAIL] << percentage(fail, weighted_test_results.size)
      percentage_arrays[UNEXECUTED] << percentage(unexecuted, weighted_test_results.size)

      complete_percentage = percentage(pass + fail, weighted_test_results.size)
    end

    unless title
      chart_bhg_test_results( {:chs => "255x30",
                              :chxl => "0:|#{complete_percentage.to_i}%"},
                              data_arrays, percentage_arrays)
    else
      chart_bhg_test_results( {:chs => "246x50",
                              :chxl => "0:|#{complete_percentage.to_i}%",
                              :chtt => title},
                              data_arrays, percentage_arrays)
    end
  end

  def chart_bhg_test_results(ch, data_arrays, percentage_arrays)
    data_arrays_chm = data_array_to_array_chm(data_arrays)

    chart_bhg_percentage_array(ch.merge(:chd => 't:' + percentage_arrays.collect {|percentage_array| percentage_array.join(",")}.join("|"),
                                        :chco => '00FF00, FF0000, FFFF00, D8D8D8',
                                        :chm => "#{data_arrays_chm.collect {|data_array_chm| data_array_chm.join("|")}.join("|")}"))
  end

  def chart_bhg_percentage_array(ch)
    chart_bhg(ch.merge(:chds => "0, 110",
                       :chbh => "20, 0",
                       :chxt => 'r'))
  end
end
