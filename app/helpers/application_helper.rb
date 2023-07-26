module ApplicationHelper
  def tooltip_message(label, content)
    "<p class='has-speedrail-tooltip' style='display: inline-block'>
    #{label}
      <svg xmlns='http://www.w3.org/2000/svg' class='h-4 w-4' style='display: inline-block; vertical-align: inherit' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
        <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z' />
      </svg>
      <span class='speedrail-tooltip p-1 rounded border border-gray-200 bg-gray-100 shadow-lg ml-4 text-sm'>#{content}</span>
    </p>".html_safe
  end

  def red_green_message(condition, green_message, red_message)
    msg = nil

    if condition
      msg = green_message
      color = 'green'
    else
      msg = red_message
      color = 'red'
    end

    "<strong style='color: #{color}'>#{msg}</strong>".html_safe
  end

  def nav_link_classes(path = nil)
    defaults = 'ml-8 whitespace-nowrap text-base font-medium text-gray-500 hover:text-gray-900'
    defaults.gsub!('gray', 'black').gsub!('-medium', '-bold') if request.path == "/#{path}"
    defaults
  end
end
