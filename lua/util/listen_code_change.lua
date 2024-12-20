local sa = require("sniprun.api")
local float = require("util.windows")

-- HACK: better floating window to display the result
local api_listener_window = function(d)
  -- 根据 d.message 的内容动态确定浮动窗口的尺寸
  local lines = vim.split(d.message, "\n")
  local input_height = #lines
  local input_width = 0
  for _, line in ipairs(lines) do
    if #line > input_width then
      input_width = #line
    end
  end

  if d.status == "ok" then
    float.create_floating_window_with_size(input_width, input_height)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    _G.some_global_variable = false
    _G.result = d.message
  elseif d.status == "error" then
    float.create_floating_window_with_size(input_width, input_height)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    _G.result = d.message
  else
    float.create_floating_window_with_size(input_width, input_height)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    _G.result = d.message
  end
end

sa.register_listener(api_listener_window)
