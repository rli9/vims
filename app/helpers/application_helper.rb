# Methods added to this helper will be available to all templates in the application.
class String
  def lines(pattern = "\r\n")
    split(pattern).map(&:strip).reject(&:empty?)
  end
end

class Array
  def every(size)
    index = 0
    while true
      slice = self.slice(index, size)
      break if slice.nil? || slice.empty?

      yield slice
      index += size
    end
  end

  #FIXME need better name
  def collect_every(size)
    collect = []

    index = 0
    while true
      slice = self.slice(index, size)
      break if slice.nil? || slice.empty?

      collect.concat(yield slice)
      index += size
    end

    collect
  end
end

class Time
  def work_year
    @work_time = work_time unless @work_time
    @work_time[:year]
  end

  def work_week
    @work_time = work_time unless @work_time
    @work_time[:week]
  end

protected
  def work_time
    year = self.year

    week = (self.yday - 1) / 7 + 1
    week = week + 1 if self.wday < ((self.yday - 1) % 7)

    if week > 52
      week = 1
      year = year + 1
    end
    {:year => year, :week => week}
  end
end

module ApplicationHelper
  def active_record(object_name)
    object_name.camelize.constantize
  end

  def page_hierarchy_tag(page_hierarchy, page_hierarchy_highlight = nil)
    page_hierarchy_highlight ||= page_hierarchy

    tag = ''

    if page_hierarchy
      if page_hierarchy.root?
        tag << page_hierarchies_tag(PageHierarchy.roots, page_hierarchy)
      else
        tag << page_hierarchy_tag(page_hierarchy.parent_page_hierarchy, page_hierarchy)
      end
      tag << page_hierarchies_tag(page_hierarchy.child_page_hierarchies, page_hierarchy_highlight)
    end
    tag
  end

  def page_hierarchies_tag(page_hierarchies, page_hierarchy_highlight)
    tag = ''
    unless page_hierarchies.empty?
      tag << '<hr width = "100%" size = "0" style = "line-height: 0; margin-top: 0; margin-bottom: 0">'
      tag << '<div width = "100%" align = "center" style = "background-color: #99ccff">'
      page_hierarchies_links = page_hierarchies.map do |page_hierarchy|
        if page_hierarchy_highlight.controller == page_hierarchy.controller && page_hierarchy_highlight.action == page_hierarchy.action
          link_to(page_hierarchy.name, {:controller => page_hierarchy.controller, :action => page_hierarchy.action, :id => 0}, :class => 'highlight')
        else
          link_to(page_hierarchy.name, :controller => page_hierarchy.controller, :action => page_hierarchy.action, :id => 0)
        end
      end
      tag << page_hierarchies_links.join("<nobr> | </nobr>")
      tag << '</div>'
      tag << '<hr width = "100%" size = "0" style = "line-height: 0; margin-top: 0; margin-bottom: 0">'
      tag << tag(:p)
    end
    tag
  end

  def show_project_name
    if @project && controller.controller_name != 'vimses'
     link_to(@project.name, {:controller => 'projects', :action => 'manage', :id => session[:project_id]})
    else
      #"<span style = \"color:#224499\">VIMS</span>"
    end
  end

  def get_main_menu
    PageHierarchy.where(parent_page_hierarchy_id: nil)
  end

  def get_projects
    @project = Member.find(session[:member_id]).projects
  end
end
