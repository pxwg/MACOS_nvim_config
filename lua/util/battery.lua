local M = {}

M.get_battery_time = function()
  local handle = io.popen("pmset -g batt")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      if result:match("charging") then
        return "Charging"
      elseif result:match("discharging") then
        return result:match("%d+:%d+") or "N/A"
      elseif result:match("finished charging") then
        return "N/A"
      end
    end
  end
  return "N/A"
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
