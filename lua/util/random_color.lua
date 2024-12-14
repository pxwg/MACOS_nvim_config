local M = {}

local function get_names()
  local names = {}
  local file_path = os.getenv("HOME") .. "/.config/nvim/lua/plugins/color.lua"
  local pattern = 'name%s*=%s*"(.-)"'
  for line in io.lines(file_path) do
    local name = line:match(pattern)
    if name then
      table.insert(names, name)
      if name == "cyberdream" then
        for i = 1, 3 do
          table.insert(names, name)
        end
      end
    end
  end
  return names
end

function M.get_random_name()
  local names = get_names()
  if #names > 0 then
    math.randomseed(os.time()) -- 设置随机数种子
    local random_index = math.random(#names)
    return names[random_index]
  end
end

return M
