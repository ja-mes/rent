module ApplicationHelper
  def isActive(controller, action = nil)
    if action == nil
      if params[:controller] == controller
        'active'
      end
    elsif params[:controller] == controller && params[:action] == action
      'active'
    elsif params[:controller] == controller && (action.include? params[:action])
      'active'
    end
  end

  def link_to_add_fields(name, f, association, cssClass, fa = nil)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    link_to "#", :onclick => h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => cssClass do
      if fa
        content_tag :i, "", class: "#{fa.html_safe}"
      else
        name
      end
    end
  end  
end
