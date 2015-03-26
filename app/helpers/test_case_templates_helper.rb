module TestCaseTemplatesHelper

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
        html << td_tag(index + 1, :rowspan => row_span)
        html << td_tag(link_to(test_case.name, {:controller => "test_cases", :action => "show", :id => test_case.id}, :popup => true), :rowspan => row_span)

        if left.nil? || left.test_target_instance.nil?
          html << td_tag('', :rowspan => row_span)
        else
          html << td_tag(left.test_target_instance.name, :rowspan => row_span)
        end

        html << tds_tag('','','')
        html << "</tr>"
      end
    end
    html << "</table>"
    html
  end
end
