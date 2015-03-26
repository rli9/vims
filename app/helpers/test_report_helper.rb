module TestReportHelper
  def check_inconsistent_test_case (test_case, type)
    row_color = "grey"

    if (type.to_s == "regression" || type.to_s == "new_fail" || type.to_s == "keep_fail")
      row_color = "red"
    end

    if type.to_s == "fix"
      row_color = "yellow"
    end

    row_color
  end

  def test_suite_report
    html = "<table border = '1' bordercolor = '#888888'>"
    html << "<tr>"
    html << th_tag('Test suite')
    html << th_tag('Test Case')
    html << th_tag('Remark')
    html << th_tag('Priority')
    html << th_tag('Status')
    html << "</tr>"
    TestReport.types.each_index do |index|
      type = TestReport.types[index]
      color_class = TestReport.color_classes[index]

      html << "<tr class = '#{color_class}'>"
      html << th_tag(type.to_s + " (#{@test_result_report[type].size})", :colspan => 6)
      html << "</tr>"

      @test_suite_report[type].each_pair do |test_suite_id, test_results|
        html << "<tr>"
        rowspan = test_results.inject(0) {|n, test_result| n + 1}
        html << td_tag(TestSuite.find(test_suite_id.to_i).name, :rowspan => span(rowspan))

        test_results.each_index do |test_result_index|
          test_result = test_results[test_result_index]
          html << td_tag(test_result.test_case.name)
          html << td_tag("")
          html << tds_tag('','',"")

          if test_result_index < test_results.size - 1
            html << "</tr>"
            html << "<tr>"
          end
        end
        html << "</tr>"
      end
    end
    html << "</table>"
    html
  end

  def report_test_suite_remark(root_test_suite)
    html = ''
    TestReport.types.each do |type|
      type_test_results = @test_suite_report[type]["#{root_test_suite.id}"]
      if type_test_results && type_test_results.size > 0
        html << "#{type_test_results.size} #{type}s. "
      else
        html << "No #{type}. "
      end
    end
    html << '<br/>'
    TestReport.types.each do |type|
      type_test_results = @test_suite_report[type]["#{root_test_suite.id}"]
      if type_test_results && type_test_results.size > 0
        html << '<br/>'
        html << "**#{type.to_s.capitalize}**"
        html << '<br/>'
        type_test_results.each do |type_test_result|
          html << "- #{type_test_result.test_case.name} []"
          html << '<br/>'
        end
      end
    end
    html
  end

  def test_result_report
    html = "<table border = '1' bordercolor = '#888888' width = '715px'>"
    html << "<tr>"
    html << td_tag('ID', :width => "3%", :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
    html << td_tag('Test Case', :width => "40%", :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
    html << td_tag('Result Remark', :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
    html << td_tag('Compare To', :width => "15%", :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
    html << td_tag('Priority', :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
    html << td_tag('Status', :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
    html << "</tr>"

    TestReport.types.each_index do |index|
      type = TestReport.types[index]
      type_names = type.to_s.split("_")
      name = ""
      type_names.each do |type_name|
        if type_names.size > 1
          name = name + type_name.capitalize + " "
        elsif type_names.size == 1
          name = type_name.capitalize
        end
      end
      color_class = TestReport.color_classes[index]
      html << "<tr class = '#{color_class}'>"
      html << td_tag(name + " (#{@test_result_report[type].size})", :colspan => 7, :bgcolor => "#EFEFEF", :style => "font-weight:600", :align => "center")
      html << "</tr>"
      @test_result_report[type].each_index do |index|
        test_report_item = @test_result_report[type][index]
        right = test_report_item.right
        left = test_report_item.left
        test_case = right.test_case
        row_color = check_inconsistent_test_case(test_case, type)
        if (type.to_s == "block" || type.to_s == "new_block")
          row_color = "red"
        end
        html << "<tr class = '#{row_color}'>"
        html << td_tag(index + 1)
        html << td_tag(link_to(test_case.name, {:controller => "test_cases", :action => "show", :id => test_case.id}), :rowspan => row_span)
        if left.nil? || left.test_target_instance.nil?
          html << td_tag('')
        else
          html << td_tag(left.test_target_instance.name)
        end
        html << tds_tag('','','')
        html << "</tr>"
      end
    end
    html << "</table>"
    raw(html)
  end

  def report_summary
    html = "Validation for #{@test_target_instance.name} is completed "

    if @test_result_report[:regression].empty? && @test_result_report[:new_fail].empty?
      html << "No regression/No new failure. "
    else
      html << "#{@test_result_report[:regression].size} regressions/#{@test_result_report[:new_fail].size} new failures. "
    end

    html << "Detail information is as follows"
    html
  end

  def indicator_report(test_target, test_target_instance, x_axis_arrays, weighted_test_results)
    percentage_arrays = [[], [], []]
    data_arrays = [[], [], []]

    x_axis_arrays.each do |item|
      test_results = weighted_test_results.select {|weighted_test_result| weighted_test_result.test_case.top_test_suite_name.downcase.eql?(item.downcase)}
      if test_results.empty?
        percentage_arrays[0] << 0
        percentage_arrays[1] << 0
        percentage_arrays[2] << 0

        data_arrays[0] << 0
        data_arrays[1] << 0
        data_arrays[2] << 0
      else
        pass = test_results.select {|test_result| test_result.test_target_pass?}.size
        fail = test_results.select {|test_result| test_result.test_target_fail?}.size

        data_arrays[0] << pass
        data_arrays[1] << fail

        total = pass + fail
        if total == 0
          percentage_arrays[0] << 0
          percentage_arrays[1] << 0
        else
          percentage_arrays[0] << percentage(pass, total)
          percentage_arrays[1] << percentage(fail, total)
        end
      end
    end

    pass_rate = average(percentage_arrays[0])

    chart_bvs_indicator_test_results( {:chs => "600x300",
                                      :chtt => "#{test_target.name} #{test_target_instance ? test_target_instance.name : ""} Test Case Health (#{pass_rate.round}% pass)",
                                      :chxl => "0:|" + x_axis_arrays.join("|") + '|1:|0%|10%|20%|30%|40%|50%|60%|70%|80%|90%|100%|110%' + '|2:|0%|10%|20%|30%|40%|50%|60%|70%|80%|90%|100%|110%' + '|3:|' + percentage_arrays[0].collect(&:to_i).join("%|") + '%'},
                                      data_arrays, percentage_arrays)
  end

  def indicator_horizontal_report(test_target, test_target_instance, x_axis_arrays, weighted_test_results, title_number)
    percentage_arrays = [[], [], []]
    data_arrays = [[], [], []]

    x_axis_arrays.each do |item|
      test_results = weighted_test_results.select {|weighted_test_result| TestCase.find(weighted_test_result.test_case_id).top_test_suite_name.to_s.downcase.eql?(item.downcase)}
      if test_results.empty?
        percentage_arrays[0] << 0
        percentage_arrays[1] << 0
        percentage_arrays[2] << 0
        data_arrays[0] << 0
        data_arrays[1] << 0
        data_arrays[2] << 0
      else
        pass = test_results.select {|test_result| test_result.test_target_pass?}.size
        fail = test_results.select {|test_result| test_result.test_target_fail?}.size
        data_arrays[0] << pass
        data_arrays[1] << fail

        total = pass + fail
        if total == 0
          percentage_arrays[0] << 0
          percentage_arrays[1] << 0
        else
          percentage_arrays[0] << percentage(pass, total)
          percentage_arrays[1] << percentage(fail, total)
        end
      end
    end
    pass_rate = average(percentage_arrays[0])
    y_axis_arrays = x_axis_arrays.reverse
    chart_height = 40 + x_axis_arrays.size * 35
    if title_number == 1
      title_name = "#{test_target.name} #{test_target_instance ? test_target_instance.name : ""} Test Case Health (#{pass_rate.round}% pass)"
    else
      title_name = "#{test_target ? test_target.name : ""} Test Case Health (#{pass_rate.round}% pass)"
    end
    raw(chart_bhs_indicator_test_results( {:chs => "550x#{chart_height}",
                                          :chtt => title_name,
                                          :chts => "000000, 12",
                                          :chxl => '|0:|0%|10%|20%|30%|40%|50%|60%|70%|80%|90%|100%|110%|' + "1:|" + y_axis_arrays.join("|") + '|2:|' + percentage_arrays[0].collect(&:to_i).reverse.join("%|") + '%'},
                                          data_arrays, percentage_arrays))
  end

  def analysis_recent_ten_build_R_NF(latest_ten_test_target_instance_status)
    title_name = "Recent #{latest_ten_test_target_instance_status.size} Build Failed Info Analysis"

    x_axis_test_target_instance_names = Array.new
    x_axis_test_target_instance_ids = Array.new
    y_axis_regression_data = Array.new
    y_axis_new_fail_data = Array.new
    latest_ten_test_target_instance_status.each do |item|
      x_axis_test_target_instance_names << item[0].name
      x_axis_test_target_instance_ids << item[0].id
      y_axis_regression_data << item[1][0]
      y_axis_new_fail_data << item[1][1]
    end
    max_r = y_axis_regression_data.sort {|x, y| y <=> x}[0]
    max_nf = y_axis_new_fail_data.sort {|x, y| y <=> x }[0]
    max_amount = max_r > max_nf ? max_r : max_nf
    max = (max_amount / 10 + 1) * 10
    step = max / 10
    y_axis_value = Array.new
    for i in 0..10
     y_axis_value << step * i
    end
    chg_x_step = 0
    chg_x_step = 100.0 / (x_axis_test_target_instance_names.size - 1) if x_axis_test_target_instance_names.size > 1
    chart_lxy_indicator_recent_ten_test_results( {:chs => "1000x300",
                                                 :chd => "t:#{y_axis_regression_data.join(',')}|#{y_axis_new_fail_data.join(',')}",
                                                 :chds => "0, #{max}, 0, #{max}",
                                                 :chdl => "Regression|NewFail",
                                                 :chco => "0099FF, FF9900",
                                                 :chtt => title_name,
                                                 :chxt => "x, y",
                                                 :chxl => "0:||#{x_axis_test_target_instance_names[0]}|1:|#{y_axis_value.join('|')}",
                                                 :chxr => "1, 0, #{max}",
                                                 :chg => "#{chg_x_step}, 5, 5, 5"
                                                })
  end

  def test_target_instance_pass_rate(test_target_instance)
    @latest_weighted_test_results = test_target_instance.test_target.latest_weighted_test_results_until(test_target_instance)
  end

  def indicator_line_report(test_target)
    pass_rate = Array.new
    @test_suites = test_target.top_test_suites.collect {|item| item.name.upcase}
    @test_target_instances = TestTargetInstance.where(test_target_id: test_target.id)
    if @test_target_instances
      @test_target_instances.each do |test_target_instance|
        percentage_arrays = [[], [], []]
        @latest_weighted_test_results = test_target.latest_weighted_test_results_until(test_target_instance)
        @test_suites.each do |item|
          test_results = @latest_weighted_test_results.select {|weighted_test_result| weighted_test_result.test_case.test_suites_names.downcase.include?item.downcase}
          if test_results.empty?
            percentage_arrays[0] << 0
            percentage_arrays[1] << 0
          else
            pass = test_results.select {|test_result| test_result.test_target_pass?}.size
            fail = test_results.select {|test_result| test_result.test_target_fail?}.size
            total = pass + fail
            if total == 0
              percentage_arrays[0] << 0
              percentage_arrays[1] << 0
            else
              percentage_arrays[0] << percentage(pass, total)
              percentage_arrays[1] << percentage(fail, total)
            end
          end
        end
        pass_rate << average(percentage_arrays[0])
      end
    end

    pass_rate.delete_if {|item| item.zero? }

    chart_line_indicator_test_results( {:chs => "500x300",
                                       :chxt => "x, y",
                                       :chxl => "1:|0%|10%|20%|30%|40%|50%|60%|70%|80%|90%|100%",
                                       :chg => "100, 10, 0, 0",
                                       :chco => "76A4FB",
                                       :cht => "lc",
                                       :chtt => "#{test_target ? test_target.name : ""} History Health (#{pass_rate.last.round}% Pass)",
                                       :chdl => "Pass Rate"},
                                       pass_rate)

  end
end
