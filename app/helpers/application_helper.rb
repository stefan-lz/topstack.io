module ApplicationHelper
  def flash_class(level)
    case level.to_s
      when 'notice' then return 'success'
      when 'alert' then return 'error'
    end
  end
end
