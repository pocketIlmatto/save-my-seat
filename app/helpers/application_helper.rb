module ApplicationHelper
  
  def display_datetime(dt)
    dt.in_time_zone(current_timezone).strftime("%m/%d/%Y %H:%M%p %Z")
  end

end
