local M = {}

M.get_battery_time = function()
  local handle = io.popen("pmset -g batt")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      if result:match("discharging") then
        local time_remaining = result:match("(%d+:%d+)")
        return time_remaining or "N/A"
      elseif result:match("charging") or result:match("charged") then
        return " "
      elseif result:match("finished charging") then
        return " "
      end
    end
  end
  return " "
end

M.get_battery_status = function()
  local handle = io.popen("pmset -g batt | grep -Eo '[0-9]+%'")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      return result:match("%d+")
    end
  end
  return "N/A"
end

return M
