local M = {}

M.get_battery_time = function()
  local handle = io.popen('pmset -g batt | grep -Eo "\\d+:\\d+"')
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      return result:match("%d+:%d+")
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
  return nil
end

return M
