module HtmlHelper
  def options(db_table, options = nil)
    unless options.nil?
      result = {}.merge(options)
    else
      result = {}
    end

    for column in db_table.content_columns
      unless result["#{column.name}"].nil?
        result["#{column.name}"] = {}.merge(result["#{column.name}"])
      else
        result["#{column.name}"] = {}
      end

      result["#{column.name}"][:edit] = true
    end
    result
  end

  def th_tags(values)
    values.collect {|value| th_tag(value)}.join
  end

  def html_content(object_name, column_name, option = nil)
    if option.nil?
      h(instance_variable_get("@#{object_name}").send(column_name))
    else
      if option[:edit]
        if option[:multiple_lines]
          text_area(object_name, column_name, 'cols' => 50, 'rows' => 10)
        else
          text_field(object_name, column_name)
        end
      else
        record_value = h(instance_variable_get("@#{object_name}").send(column_name))
        if option[:multiple_lines]
          record_value.gsub(/(\r\n)|(\n)/, "<br></br>")
        else
          record_value
        end
      end
    end
  end

  def vertical_table_tag_single(db_table, object_name, options = nil)
    html = start_table_tag

    if options.nil?
      for column in db_table.content_columns
        next if column.name == "created_at" || column.name == "updated_at"
        html << tr_tag(th_tag(column.human_name) + td_tag(h(instance_variable_get("@#{object_name}").send(column.name))))
      end
    else
      for column in db_table.content_columns
        next if column.name == "created_at" || column.name == "updated_at"
        html << tr_tag(th_tag(column.human_name) + td_tag(html_content(object_name, column.name, options["#{column.name}"])))
      end
    end

    html << end_table_tag
    html
  end

  def button_tag(value, options)
    submit_tag(value, type: 'button', class: 'css_button', :onClick => "parent.location = '#{url_for(options)}'")
  end

  def submit_button_green_tag(value)
    submit_tag(value, class: 'add_button')
  end

  def submit_button_red_tag(value)
    submit_tag(value, class: 'cancel_button')
  end

  def cancel_button_tag(value, options)
    submit_tag(value, type: 'button', class: 'cancel_button', :onClick => "parent.location = '#{url_for(options)}'")
  end

  def cancel_back_button_tag(value)
    submit_tag(value, type: 'button', class: 'cancel_button', :onClick => "history.go(-1)")
  end

  def left_button_tag(value, options)
    submit_tag(value, type: 'button', class: 'left_content_button', :onClick => "parent.location = '#{url_for(options)}'")
  end

  def button_green_tag(value)
    submit_tag(value, type: 'button', class: 'add_button', :id => 'update_rs', :onClick => "test_result(this);", :name => "commit")
  end

  def button_red_tag(value)
    submit_tag(value, type: 'button', class: 'cancel_button', :id => 'del_rs', :onClick => "test_result(this);", :name => "")
  end

  def submit_button_search_tag(value)
    submit_tag(value, class: 'search_button')
  end

  def search_button_tag(value)
    submit_tag(value, type: 'button', class: 'search_button', :name => "search_button")
  end

  def test_case_button_link(value, options)
    submit_tag(value, type: 'button', class: options[:class], :onClick => "parent.location = '#{url_for(options)}'")
  end

  def submit_tag_custom_class_id(value, options)
    submit_tag(value, type: 'button', class: options[:class], :id => options[:id])
  end

  def test_case_action_button(value, options)
    submit_tag(value, type: 'button', class: options[:class])
  end

  def test_case_submit_button_green_tag(value, options)
    submit_tag(value, type: 'button', class: 'add_button', :id => options[:id])
  end

  def test_case_submit_button_red_tag(value, options)
    submit_tag(value, type: 'button', class: 'cancel_button', :id => options[:id])
  end

  def device_menu_div(label_name, active_flag)
    if active_flag == true
      div_content = "<div class = 'device_top_menu top_menu_active'>"
    else
      div_content = "<div class = 'device_top_menu'>"
    end
    div_content << label_name
    div_content << "</div>"
    raw(div_content)
  end

  def current_action_flag(current_action_name, compare_name)
    current_action_name.to_s == compare_name.to_s
  end

  def table_header_tag(db_table)
    render = ''
    for column in db_table.content_columns
      render << content_tag(:th, column.human_name, :bgcolor => '#9acd32')
    end
    render
  end

  def table_line_tag(db_table, object_name, edit = false)
    render = ''

    if edit
      for column in db_table.content_columns
        render << content_tag(:td, text_field(object_name, column.name))
      end
    else
      for column in db_table.content_columns
        render << content_tag(:td, h(instance_variable_get("@#{object_name}").send(column.name)), :bgcolor => 'silver')
      end
    end
    render
  end

  def fit_size(bits, size)
    while bits.size < size
      bits = '0' + bits
    end
    if bits.size > size
      bits = bits[bits.size - size..bits.size - 1]
    end
    bits
  end

  def table_tag(db_table, object_name, edit = false)
    render = ''
    render << start_table_tag
    render << content_tag(:tr, table_header_tag(db_table))
    render << table_line_tag(db_table, object_name, edit)
    render << end_table_tag
  end

  def td_tag_single_object(db_table, object_name, options = nil)
    html = ''

    if options.nil?
      for column in db_table.content_columns
        html << td_tag(h(instance_variable_get("@#{object_name}").send(column.name)))
      end
    else
      for column in db_table.content_columns
        html << td_tag(html_content(object_name, column.name, options["#{column.name}"]))
      end
    end

    html
  end

  def start_table_tag
    "<table border = '1' bordercolor = '#888888'>"
  end

  def end_table_tag
    "</table>"
  end

  def th_tag(content = nil, options = {})
    options[:bgcolor] ||= '#9acd32'

    content_tag(:th, content, options)
  end

  def td_tag(content = nil, options = {})
    options[:bgcolor] ||= 'silver'

    raw(content_tag(:td, content, options))
  end

  def tr_tag(content = nil, options = {})
    content_tag(:tr, content, options)
  end

  def start_child_ul_tag
    "<ul style = 'display: none;' class = 'children'>"
  end

  def end_child_ul_tag
    "</ul>"
  end

  def green
    '#00FF00'
  end

  def red
    '#FF0000'
  end

  def yellow
    '#FFFF00'
  end

  def grey
    '#d8d8d8'
  end

  def white
    '#ffffff'
  end

  def link_to_edit_test_case(test_case)
    link_to(image_tag("edit.gif", :alt => 'edit'), {:controller => "test_cases", :action => "edit", :id => test_case}, :popup => true)
  end

  def link_to_edit_test_case_test_suite(test_case, test_suite)
    link_to(image_tag("edit.gif", :alt => 'edit'), {:controller => "test_cases", :action => "edit", :id => test_case, :test_suite_id => test_suite}, :popup => true)
  end

  def tr_edit_text_field(object_name, column_name)
    th_tag = th_tag(column_name.humanize)
    td_tag_show = td_tag(instance_variable_get("@#{object_name}").send(column_name))

    "<tr>#{th_tag}#{td_tag_show}#{th_tag}#{td_tag(text_field(object_name, column_name))}</tr>"
  end

  def tr_edit_select(object_name, column_name, columns)
    th_tag = th_tag(column_name.humanize)
    column = columns.detect {|column| column.id == instance_variable_get("@#{object_name}").send(column_name)}
    td_tag_show = td_tag(column ? column.name : '')
    tg_tag_edit = td_tag(select(object_name, column_name, columns.collect {|column| [column.name, column.id]}, {:include_blank => true }))

    "<tr>#{th_tag}#{td_tag_show}#{th_tag}#{tg_tag_edit}</tr>"
  end

  def ths_tag_test_data_standard
    html = ''

    html << th_tag('Pass')
    html << th_tag('Fail')
    html << th_tag('Unexecuted')
    html << th_tag('Case Fail')
    html << ths_tag('Total', 'Pass Rate %')

    raw(html)
  end

  def tds_tag_test_data_standard(test_datas)
    stats = TestResult.stats(test_datas)

    html = ''
    html << td_tag(stats[:test_target_pass])
    html << td_tag(stats[:test_target_fail])
    html << td_tag(stats[:test_target_unexecuted])
    html << td_tag(stats[:test_case_fail])
    html << td_tag(test_datas.size)
    html << td_tag_pass_rate(stats[:pass_rate])

    raw(html)
  end

  def color_for_test_data(test_data)
    if test_data.test_target_fail?
      red
    elsif test_data.test_target_pass?
      green
    elsif test_data.test_target_unexecuted?
      grey
    else
      white
    end
  end

  def color_class_for_test_data(test_data)
    if test_data.test_target_fail?
      'red'
    elsif test_data.test_target_pass?
      'green'
    elsif test_data.test_target_unexecuted?
      'white'
    else
      'grey'
    end
  end

  def td_tag_test_data_result(test_data, rowspan = nil)
    if test_data.nil? || test_data.test_target_unexecuted?
      td_tag(link_to_edit_result('Unexecuted', test_data), {class: 'grey', :rowspan => span(rowspan)})
    elsif test_data.test_case_fail?
      td_tag(link_to_edit_result('Case Fail', test_data), {class: 'red', :rowspan => span(rowspan)})
    elsif test_data.test_target_fail?
      td_tag(link_to_edit_result('Fail', test_data), {class: 'red', :rowspan => span(rowspan)})
    elsif test_data.test_target_pass?
      td_tag(link_to_edit_result('Pass', test_data), {class: 'green', :rowspan => span(rowspan)})
    end
  end

  def link_to_edit_result(link_text, link_data)
    link_to(link_text, {:controller => 'test_results', :action => 'edit_test_result', :id => link_data}, class: "link_black")
  end

  def color_option_for_test_data(test_data)
    {:bgcolor => color_for_test_data(test_data) }
  end

  def html_name(name)
    h(name).gsub(/\s/, '&nbsp;')
  end

  def html_content(object_name, column_name, option = nil)
    if option.nil?
      h(instance_variable_get("@#{object_name}").send(column_name))
    else
      if option[:edit]
        if option[:multiple_lines]
          text_area(object_name, column_name, 'cols' => 50, 'rows' => 10)
        else
          text_field(object_name, column_name)
        end
      else
        record_value = h(instance_variable_get("@#{object_name}").send(column_name))
        if option[:multiple_lines]
          record_value.gsub(/(\r\n)|(\n)/, "<br></br>")
        else
          record_value
        end
      end
    end
  end

  def ths_tag(*contents)
    raw(contents.flatten.collect {|content| th_tag(content)}.join)
  end

  def th_tag(content, options = {})
    raw(content_tag(:th, content, options))
  end

  def tds_tag(*contents)
    raw(contents.flatten.collect {|content| td_tag(content)}.join)
  end

  def td_tag(content = nil, options = {}, &block)
    if block_given?
      concat("<td>", block.binding)
      yield
      concat("</td>", block.binding)
    else
      content_tag(:td, content, options)
    end
  end

  def tr_tag(content = nil, options = {}, &block)
    if block_given?
      concat "<tr>"
      yield
      concat "</tr>"
    else
      content_tag(:tr, content, options)
    end
  end

  def table_tag(&block)
    concat("<table border = '1' bordercolor = '#888888'>", block.binding)
    yield
    concat("</table>", block.binding)
  end

  def option_tags(collection, field)
    collection.collect {|item| "<option value = '#{item.id}'>" + item.send(field) + "</option>" }.join
  end

  def td_tag_pass_rate(pass_rate)
    if pass_rate >= 90
      color_option = {class: 'green' }
    elsif pass_rate >= 70 && pass_rate < 90
      color_option = {class: 'yellow' }
    else
      color_option = {class: 'red' }
    end
    td_tag(pass_rate, color_option)
  end

  def table_tag_parent_test_suites(child_test_suite, test_suites)
    max_recursive_child_test_suite_depth = test_suites.collect(&:max_recursive_child_test_suite_depth).max || 0

    html = "<table id = 'table_#{test_suites[0].name}' border = '1' bordercolor = '#888888' width = '100%'>"

    html << tr_tags_parent_test_suites(child_test_suite, test_suites, 0, max_recursive_child_test_suite_depth + 1)

    html << "</table>"
    html
  end

  def tr_tags_parent_test_suites(child_test_suite, test_suites, level, max_colspan)
    html = ''

    color_options = [ {}, {:bgcolor => '#B2A1C7'}]
    test_suites.each_index do |index|
      test_suite = test_suites[index]
      color_option = color_options[level > 0 ? 1 : 0]

      if test_suite.id != child_test_suite.id && !test_suite.recursive_child_test_suite_of?(child_test_suite)
        html << "<tr>"

        level.times {|i| html << td_tag("&nbsp;&nbsp;&nbsp;&nbsp;")} if level > 0

        option = color_option.clone
        option[:colspan] = max_colspan - level

        checked = test_suite.parent_test_suite_of?(child_test_suite)
        html << td_tag(check_box_tag("parent_test_suite_ids[]", test_suite.id, !checked.nil?, :id => "input_checkbox_#{test_suite.name}") + test_suite.name + "<br/>", option)

        html << "</tr>"

        html << tr_tags_parent_test_suites(child_test_suite, test_suite.child_test_suites, level + 1, max_colspan)
      end
    end

    html
  end

  def tr_tags_test_suites(test_suites, level, max_colspan)
    html = ''

    color_options = [ {}, {:bgcolor => '#B2A1C7'}]
    test_suites.each_index do |index|
      test_suite = test_suites[index]
      color_option = color_options[level > 0 ? 1 : 0]
      test_cases = test_suite.test_cases

      html << "<tr id = 'tr_#{h(test_suite.name)}'>"
      html << td_tag(level)

      level.times {|i| html << td_tag("&nbsp;&nbsp;&nbsp;&nbsp;")}

      option = color_option.clone
      option[:colspan] = max_colspan - level

      html << td_tag(h(test_suite.name).gsub(/\s/, '&nbsp;'), option)
      html << td_tag(test_cases.size, color_option)
      html << td_tag(link_to("Show", :controller => "test_cases", :action => "list", :test_suite_id => test_suite.id, :id => 0), color_option)

      if test_suite.deletable?
        to_do_delete = "<nobr> | </nobr>" + link_to(image_tag("delete.gif", :alt => 'delete'), {:action => 'delete', :id => test_suite}, :confirm => "Are you sure to delete #{test_suite.name}?")
      else
        to_do_delete = ''
      end

      html << td_tag(link_to(image_tag("edit.gif", :alt => 'edit'), :action => "edit", :id => test_suite) + "<nobr> | </nobr>" +
      link_to("Add Test Case", :action => "new_test_case_test_suite_association", :id => test_suite) + to_do_delete, color_option)
      html << "</tr>"

      html << tr_tags_test_suites(test_suite.child_test_suites, level + 1, max_colspan)
    end
    html
  end

  def test_suite_view
    max_depth = @test_suites.collect(&:max_recursive_child_test_suite_depth).max
    max_depth ||= 0

    html = "<table>"
    html << "<tr>"
    html << th_tag('No.', :rowspan => 3)
    html << th_tag('Test Suite', :rowspan => 3, :colspan => max_depth + 1)
    @test_suite_view_hash.each_pair do |test_target_instance_id, test_target_instance_hash|
      html << th_tag(TestTargetInstance.find(test_target_instance_id).name, :colspan => test_target_instance_hash.size * 8)
    end
    html << "</tr>"

    html << "<tr>"
    @test_suite_view_hash.each_value do |test_target_instance_hash|
      test_target_instance_hash.each_key do |test_result_suite_id|
        if test_result_suite_id.to_i == 0
          html << th_tag('', :colspan => 8)
        else
          html << th_tag(TestResultSuite.find(test_result_suite_id.to_i).name, :colspan => 8)
        end
      end
    end
    html << "</tr>"

    html << "<tr>"
    @test_suite_view_hash.each_key do |test_target_instance_id|
      @test_suite_view_hash[test_target_instance_id].size.times do |i|
        html << ths_tag_test_data_standard
      end
    end
    html << "</tr>"

    html << recursive_test_suite_view(TestSuite.top_test_suites(@test_suites), @test_suites, 0, max_depth + 1)

    html << "</table>"
    html
  end

  def recursive_test_suite_view(top_test_suites, full_test_suites, level, max_colspan)
    html = ''
    color_options = [ {}, {:bgcolor => '#B2A1C7'}]
    top_test_suites.each_index do |index|
      root_test_suite = top_test_suites[index]
      color_option = color_options[level > 0 ? 1 : 0]
      html << "<tr>"
      html << td_tag(level)
      level.times {|i| html << td_tag("&nbsp;&nbsp;&nbsp;&nbsp;")}
      option = color_option.clone
      option[:colspan] = max_colspan - level
      html << td_tag(h(root_test_suite.name).gsub(/\s/, '&nbsp;'), option)
      @test_suite_view_hash.each_value do |test_target_instance_hash|
        test_target_instance_hash.each_key do |test_result_suite_id|
          association = test_target_instance_hash[test_result_suite_id].find {|assoc| assoc.test_suite.id == root_test_suite.id}
          html << tds_tag_test_data_standard(association.nil? ? [] : association.test_results)
        end
      end
      html << "</tr>"
      child_top_test_suites = root_test_suite.child_test_suites.select do |child_test_suite|
        full_test_suites.detect {|full_test_suite| full_test_suite.id == child_test_suite.id}
      end
      html << recursive_test_suite_view(child_top_test_suites, full_test_suites, level + 1, max_colspan)
    end
    html
  end

  def span(size)
    (size.nil? || size <= 0) ? 1 : size
  end

  def percentage(a, b)
    a.to_f / b.to_f * 100
  end

  def average(items)
    sum = 0
    count = 0
    items.each do |item|
      next if item == 0

      sum = sum + item
      count = count + 1
    end
    count == 0 ? 0 : sum.to_f / count.to_f
  end

  def show_test_case_test_suites(test_case)
    html = ""
    test_suites = test_case.recursive_test_case_test_suites
    if test_suites
      test_suites.each do |test_suite|
        html << ">" + test_suite.name
      end
    end
    raw(html)
  end

  def show_test_case_test_suites_link(test_case)
    html = ""
    test_suites = test_case.recursive_test_case_test_suites
    if test_suites
      test_suites.each do |test_suite|
        html << ">" + link_to(test_suite.name, :controller => 'test_suites', :action => 'folder_list', :id => 0, :test_suite_id => test_suite.id)
      end
    end
    raw(html)
  end

  def jpopup_close_button(button_text)
    html = "<div class = 'jpopup_cancel_button'>"
    html << button_text
    html << "</div>"
    raw(html)
  end

  def jquery_jpopup_close_button(button_text, id_name)
    html = "<div class = 'jpopup_cancel_button' id = '"
    html << id_name
    html << "'>"
    html << button_text
    html << "</div>"
    raw(html)
  end

  def show_order_img(direction)
    html = "<img border = '0' src = '/images/"
    if direction == "asc"
      html << "dir_asc.png"
    elsif direction == "desc"
      html << "dir_desc.png"
    elsif direction == "forward"
      html << "dir_forward.png"
    elsif direction == "backward"
      html << "dir_backward.png"
    end
    html << "'>"
    raw(html)
  end
end
