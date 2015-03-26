class AddNewMenuData < ActiveRecord::Migration
  def up
    new_menus = Array.new
    new_menus << Hash["name", "Configure", "controller", "bug_tracks", "action", "config_address", "parent_page_hierarchy_id", 4, "created_at", Time.now, "updated_at", Time.now]
    new_menus << Hash["name", "Map", "controller", "bug_tracks", "action", "map_bug_to_case", "parent_page_hierarchy_id", 4, "created_at", Time.now, "updated_at", Time.now]
    new_menus << Hash["name", "View Case to Bug", "controller", "bug_tracks", "action", "test_case_list", "parent_page_hierarchy_id", 4, "created_at", Time.now, "updated_at", Time.now]
    new_menus << Hash["name", "View Bug to Case", "controller", "bug_tracks", "action", "index", "parent_page_hierarchy_id", 4, "created_at", Time.now, "updated_at", Time.now]
    new_menus.each do |menu|
      new_menu = PageHierarchy.new(menu)
      new_menu.save
    end
    old_hsd_menus = PageHierarchy.where(["parent_page_hierarchy_id = ? AND name like ?", 4, "%HSD%"])
    old_hsd_menus.each do |old_hsd_menu|
        new_hsd_menu = PageHierarchy.new
        new_hsd_menu.name = old_hsd_menu.name
        new_hsd_menu.controller = old_hsd_menu.controller
        new_hsd_menu.action = old_hsd_menu.action
        new_hsd_menu.parent_page_hierarchy_id = 44
        new_hsd_menu.created_at = Time.now
        new_hsd_menu.updated_at = Time.now
        old_hsd_menu.destroy if new_hsd_menu.save
    end
    PageHierarchy.where('parent_page_hierarchy_id = ? AND name LIKE ?', 44, '%HSD%').update_all(:parent_page_hierarchy_id => 4)
    PageHierarchy.where('name = ?', 'Bug Management').update_all(:name => "Bug")
  end

  def down
    del_menus = PageHierarchy.where(controller: "bug_tracks")
    del_menus.each do |del_menu|
      del_menu.destroy
    end
  end
end
