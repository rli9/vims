module AjaxHelper
  def link_to_remote_delete(name, action, object)
     link_to_remote(name, :url => {:action => action, :id => object.id}, 
                    :method => 'post', :confirm => 'are you sure to delete?', 
                    :complete => visual_effect(:fade, "#{object.id}", :duration => 0.1))
  end
  
  def link_to_remote_update(name, action, object)
    link_to_remote(name, 
                  {:url => {:action => action, :id => object.id}, 
                   :update => action, :submit => "#{object.id}"})
  end
  
  def link_to_remote_copy(name, action, object, target = 'create')
    link_to_remote(name, 
                  {:url => {:action => action, :id => object.id}, 
                   :update => {:success => target, :failure => "#{action}_failure"}, 
                   :position => :after, 
                   :submit => "#{object.id}"})
  end
  
  def link_to_remote_create(name, action, url_options = {}, target = 'create')
    link_to_remote(name, 
                  {:url => {:action => action, :id => 0}.merge(url_options), 
                   :update => {:success => target, :failure => "#{action}_failure"}, 
                   :position => :after, 
                   :submit => target})
  end
end
