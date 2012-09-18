module ApplicationHelper

  def base64_image image_data
      "<img src=#{image_data}/>".html_safe
  end
end
