module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def resource_path(resource)
    if resource.instance_of? Medicine
      medicine_path(resource)
    else
      user_profile_path(resource)
    end
  end
end
