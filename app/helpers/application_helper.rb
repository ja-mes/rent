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

  def date_value(obj)
    if obj.new_record?
      Time.now.strftime("%m/%d/%Y")
    else
      obj.date.strftime("%m/%d/%Y")
    end
  end
end
